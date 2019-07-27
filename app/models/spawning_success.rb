class SpawningSuccess < ApplicationRecord
  HEADERS = {
      TAG: "Tag",
      SHL_CASE_NUMBER: "SHL Case Number",
      SPAWNING_DATE: "Spawning_date",
      DATE_ATTEMPTED:   "Date_attempted",
      SPAWNING_SUCCESS:  "Spawning_success",
      NUMBER_OF_EGGS_SPAWNED: "Number of eggs spawned (if female)"
  }

  validates :shl_case_number, presence: true

  def cleanse_data!
    tag = tag.to_s&.strip&.upcase
    slh_case_number = shl_case_number.to_s&.strip&.upcase
    spawning_success = spawning_success.to_s&.strip&.upcase
  end
end
