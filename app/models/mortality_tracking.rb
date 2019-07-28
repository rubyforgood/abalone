class MortalityTracking < ApplicationRecord
  include Raw

  HEADERS = {
    MORTALITY_DATE: "Mortality_date",
    COHORT: "Cohort",
    SHL_CASE_NUMBER: "SHL number",
    SPAWNING_DATE: "Spawning_date",
    SHELL_BOX: "Shell_box",
    SHELL_CONTAINER: "Shell_container",
    ANIMAL_LOCATION: "Animal_location",
    NUMBER_MORTS: "\# Morts",
    APPROXIMATION:"Approximation?",
    PROCESSED_BY_SHL: "Processed by SHL?",
    INITIALS: "Initials",
    TAGS: "Tag(s)",
    COMMENTS: "Comments"
  }

end
