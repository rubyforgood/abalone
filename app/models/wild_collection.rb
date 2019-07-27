class WildCollection < ApplicationRecord
  include Raw

  HEADERS = {
    TAG: "Tag",
    COLLECTION_DATE: "Collection_date",
    GENERAL_LOCATION: "General Location",
    PRECISE_LOCATION: "Precise Location",
    COLLECTION_COODINATES: "Collection_coodinates",
    PROXIMITY_TO_NEAREST_NEIGHBOR: "Proximity to nearest neighbor (m)",
    COLLECTION_METHOD_NOTES: "Collection method notes",
    FOOT_CONDITION_NOTES: "Foot condition notes",
    COLLECTION_DEPTH: "Collection_depth_(m)",
    LENGTH: "Length",
    WEIGHT: "Weight",
    GONAD_SCORE: "Gonad Score",
    PREDICTED_SEX: "Predicted Sex",
    INITIAL_HOLDING_FACILITY: "Initial holding facility",
    FINAL_HOLDING_FACILITY_AND_DATE_OF_ARRIVAL: "Final holding facility & date of arrival",
    OTC_TREATMENT_COMPLETION_DATE: "OTC treatment completion date"
  }
end
