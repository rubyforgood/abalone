class Pedigree < ApplicationRecord
  include Raw

  HEADERS = {
    COHORT: "Cohort",
    SHL_CASE_NUMBER: 'SHL Case #',
    SPAWNING_DATE: 'Spawning date',
    MOTHER: 'Mother',
    FATHER: 'Father',
    SEPERATE_CROSS_WITHIN_COHORT: "Separate crosses within cohort (F = female, M=male)"
  }
end
