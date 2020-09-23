class MeasurementTypesController < ApplicationController
  before_action :set_measurement_type, only: [:edit, :update, :destroy]

  def index
    @measurement_types = MeasurementType.for_organization(current_organization)
  end

  def new
    @measurement_type = MeasurementType.new
  end

  def create
    @measurement_type = MeasurementType.new(measurement_type_params)
    if @measurement_type.save
      redirect_to measurement_types_path, notice: 'Measurement Type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @measurement_type.update(measurement_type_params)
      redirect_to measurement_types_path, notice: 'Measurement Type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @measurement_type.destroy
    redirect_to measurement_types_url, notice: 'Measurement Type was successfully destroyed.'
  end

  def edit; end

  private

  def set_measurement_type
    @measurement_type = MeasurementType.find(params[:id])
  end

  def measurement_type_params
    params.require(:measurement_type).permit(
      :name,
      :unit
    ).merge(organization_id: current_organization.id)
  end
end
