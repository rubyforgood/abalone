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

  # Note: Case is meaningful for spawning_success. n, Y and y mean different things.
  def cleanse_data!
    self.tag = self.tag.to_s&.strip&.upcase
    self.shl_case_number = self.shl_case_number.to_s&.strip&.upcase
  end
end
