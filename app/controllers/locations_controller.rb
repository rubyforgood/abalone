class LocationsController < ApplicationController
  before_action :set_facility
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = @facility.locations
  end

  def show
    @enclosures = @location.enclosures
  end

  def new
    @location = Location.new
  end

  def edit; end

  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to facility_location_path(@facility, @location), notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  def update
    if @location.update(location_params)
      redirect_to facility_location_path(@facility, @location), notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @location.destroy
    redirect_to facility_locations_url(@facility), notice: 'Location was successfully destroyed.'
  end

  private

  def set_location
    @location = @facility.locations.find(params[:id])
  end

  def set_facility
    @facility = Facility.find(params[:facility_id])
  end

  def location_params
    params.require(:location).permit(:name).merge(organization_id: current_organization.id, facility_id: params[:facility_id])
  end
end
