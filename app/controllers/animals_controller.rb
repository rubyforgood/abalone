class AnimalsController < ApplicationController
  before_action :set_animal, only: [:show, :edit, :update, :destroy]

  def index
    @animals = Animal.for_organization(current_organization)
  end

  def new
    @animal = Animal.new
  end

  def create
    @animal = Animal.new(animal_params)

    params[:animal][:shl_numbers_codes].split(",").each do |code|
      @animal.shl_numbers.find_or_initialize_by(code: code)
    end

    if @animal.save
      redirect_to @animal, notice: 'Animal was successfully created.'
    else
      render :new
    end
  end

  def update
    @animal.assign_attributes(animal_params)

    new_codes = params[:animal][:shl_numbers_codes].split(",").map do |code|
      @animal.shl_numbers.find_or_initialize_by(code: code.strip)
    end

    @animal.shl_numbers.where.not(id: new_codes.map(&:id)).destroy_all

    if @animal.save
      redirect_to @animal, notice: 'Animal was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @animal.destroy
    redirect_to animals_url, notice: 'Animal was successfully destroyed.'
  end

  def show; end

  def edit; end

  def csv_upload; end

  def import
    if params[:animal_csv].content_type == 'text/csv'
      upload = FileUpload.create(user: current_user, organization: current_organization, status: 'Pending',
                                 file: params[:animal_csv])

      ImportAnimalsJob.perform_later(upload)

      redirect_to animals_path, notice: 'Processing file...'
    else
      redirect_to csv_upload_animals_path, error: 'Invalid file type. Please upload a CSV.'
    end
  end

  private

  def set_animal
    @animal = Animal.find(params[:id])
  end

  def animal_params
    params.require(:animal).permit(
      :collection_year,
      :date_time_collected,
      :collection_position,
      :pii_tag,
      :tag_id,
      :sex
    ).merge(organization_id: current_organization.id)
  end
end
