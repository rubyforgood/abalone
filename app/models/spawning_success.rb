class SpawningSuccess < ApplicationRecord
  include Raw

  HEADERS = {
      TAG: "Tag",
      SHL_CASE_NUMBER: "SHL Case Number",
      SPAWNING_DATE: "Spawning_date",
      DATE_ATTEMPTED:   "Date_attempted",
      SPAWNING_SUCCESS:  "Spawning_success",
      NUMBER_OF_EGGS_SPAWNED: "Number of eggs spawned (if female)"
  }
end
