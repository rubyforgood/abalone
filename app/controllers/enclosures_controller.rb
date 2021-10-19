class EnclosuresController < ApplicationController
  before_action :set_locations, only: %i[new edit]
  load_and_authorize_resource

  def index
    @enclosures = Enclosure.for_organization(current_organization).includes(location: :facility)

    respond_to do |format|
      format.html
      format.csv { send_data @enclosures.to_csv, filename: "#{Date.today.iso8601}-enclosures.csv" }
    end
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

  def csv_upload; end

  def import
    if params[:enclosure_csv].content_type == 'text/csv'
      upload = FileUpload.create(user: current_user, organization: current_organization, status: 'Pending',
                                 file: params[:enclosure_csv])

      ImportEnclosuresJob.perform_later(upload)

      redirect_to enclosures_path, notice: 'Processing file...'
    else
      redirect_to csv_upload_enclosures_path, error: 'Invalid file type. Please upload a CSV.'
    end
  end

  private

  def enclosure_params
    params.require(:enclosure).permit(:location_id, :name).merge(organization_id: current_organization.id)
  end

  def set_locations
    @locations = Location.for_organization(current_user.organization).sort_by do |location|
      location.name_with_facility.downcase
    end
  end
end
