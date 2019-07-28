class PopulationEstimate < ApplicationRecord
  include Raw

  HEADERS = {
    SAMPLE_DATE: "Sample_date",
    SHL_CASE_NUMBER: "SHL Case Number",
    SPAWNING_DATE: "Spawning_date",
    LIFESTAGE: "lifestage",
    ABUNDANCE: "abundance",
    FACILITY: "facility",
    NOTES: "Notes"
  }
end
