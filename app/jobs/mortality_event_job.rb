class MortalityEventJob < ApplicationJob
  include ImportJob

  HEADERS = [
    "Date",
    "Subject Type",
    "Measurement Type",
    "Value",
    "Measurement Event",
    "Enclosure Name",
    "Cohort Name",
    "Tag",
    "Reason"
  ].freeze
end
