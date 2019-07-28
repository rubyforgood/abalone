class MortalityTracking < ApplicationRecord
  include Raw

  HEADERS = {
    COHORT: "cohort",
    SHL_CASE_NUMBER: "shl_case_number",
    SHELL_CONTAINER: "shell_container",
    ANIMAL_LOCATION: "animal_location",
    APPROXIMATION: "approximation",
    PROCESSED_BY_SHL: "processed_by_shl",
    INITIALS: "initials",
    TAGS: "tags",
    COMMENTS: "comments"
  }

end
