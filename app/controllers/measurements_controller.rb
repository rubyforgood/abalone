class MeasurementsController < ApplicationController
  before_action :authorize_admin!, only: %i[edit]
  before_action :set_measurement, only: %i[show edit update]

  def index
    @pagy, @measurements = pagy(Measurement.all)
  end

  def show; end

  def edit; end

  def update
    if @measurement.update(measurement_params)
      redirect_to @measurement, notice: 'Measurement was successfully updated.'
    else
      render :edit
    end
  end

  def new; end

  helper_method def subject_name_label
    subject_label = {
      "Animal" => "Animal Tag",
      "Cohort" => "Cohort Name",
      "Enclosure" => "Enclosure Name"
    }

    subject_label[@measurement.subject_type]
  end

  helper_method def subject_name_value
    subject_value = {
      "Animal" => @measurement.animal_tag,
      "Cohort" => @measurement.cohort_name,
      "Enclosure" => @measurement.enclosure_name
    }

    subject_value[@measurement.subject_type]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_measurement
    @measurement = Measurement.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def measurement_params
    params.require(:measurement).permit(
      :value,
      :subject_type,
      :measurement_type_id
    ).merge(organization_id: current_organization.id)
  end
end
