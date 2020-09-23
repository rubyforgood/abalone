class EnclosuresController < ApplicationController
  before_action :set_enclosure, only: [:show, :edit, :update, :destroy]

  def index
    @enclosures = Enclosure.for_organization(current_organization).includes(:facility)
  end

  def show; end

  def new
    @enclosure = Enclosure.new
  end

  def create
    @enclosure = Enclosure.new(enclosure_params)
    if @enclosure.save
      redirect_to enclosure_path(@enclosure), notice: 'Enclosure was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @enclosure.update(enclosure_params)
      redirect_to enclosure_path(@enclosure), notice: 'Enclosure was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @enclosure.destroy
    redirect_to enclosures_url, notice: 'Enclosure was successfully destroyed.'
  end

  private

  def set_enclosure
    @enclosure = Enclosure.find(params[:id])
  end

  def enclosure_params
    params.require(:enclosure).permit(:facility_id, :name).merge(organization_id: current_organization.id)
  end
end
