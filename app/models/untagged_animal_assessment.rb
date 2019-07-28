class UntaggedAnimalAssessment < ApplicationRecord
  HEADERS = {
    MEASUREMENT_DATE: "Measurement_date",
    COHORT: "Cohort",
    SPAWNING_DATE: "Spawning_date",
    GROWOUT_RACK: "Growout_Rack",
    GROWOUT_COLUMN: "Growout_Column",
    GROWOUT_TROUGH: "Growout_Trough",
    LENGTH: "Length (mm)",
    MASS: "Mass (g)",
    GONAD_SCORE: "Gonad Score",
    PREDICTED_SEX: "Predicted Sex",
    NOTES: "Notes"
  }

  def measurement_date=(measurement_date_str)
    write_attribute(:measurement_date, DateTime.strptime(measurement_date_str, '%m/%d/%y'))
  end

  def spawning_date=(spawning_date_str)
    write_attribute(:spawning_date, DateTime.strptime(spawning_date_str, '%m/%d/%y'))
  end

  def lengths_for_measurement(measurement_event_id)
    select(length).where(measurement_event_id: measurement_event_id)
  end
end
