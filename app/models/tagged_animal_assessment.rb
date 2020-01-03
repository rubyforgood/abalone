class TaggedAnimalAssessment < ApplicationRecord
  include Raw

  HEADERS = {MEASUREMENT_DATE: "Measurement_date",
        SHL_CASE_NUMBER: "SHL_case_number",
        SPAWNING_DATE: "Spawning_date",
        TAG: "Tag",
        FROM_GROWOUT_RACK: "From_Growout_Rack",
        FROM_GROWOUT_COLUMN: "From_Growout_Column",
        FROM_GROWOUT_TROUGH: "From_Growout_Trough",
        TO_GROWOUT_RACK: "To_Growout_Rack",
        TO_GROWOUT_COLUMN: "To_Growout_Column",
        TO_GROWOUT_TROUGH: "To_Growout_Trough",
        LENGTH: "Length",
        GONAD_SCORE: "Gonad_Score",
        PREDICTED_SEX: "Predicted_Sex",
        NOTES: "Notes",
    }

  def measurement_date=(measurement_date_str)
    write_attribute(:measurement_date, DateTime.strptime(measurement_date_str, '%m/%d/%y'))
  end

  def spawning_date=(spawning_date_str)
    write_attribute(:spawning_date, DateTime.strptime(spawning_date_str, '%m/%d/%y'))
  end

  def self.lengths_for_measurement(processed_file_id)
    # group by bin (1cm). need constant of bins
      # groups = select(:length).where(processed_file_id: processed_file_id).map { |record| record.length.to_f }
    # count = count of all animals from that spreadsheet

    # total = total number of estimated animals from cohort (will need PopulationEstimate minus Mortality)

    # for each group, num / count * total. will come up with a whole number, like 20. keep 20 with the size bin {"2cm" => 20}

    # for each group, shovel in 2.times {data << 20} to an array

    # data = [20,20]
  end

  def cleanse_data!
  end
end
