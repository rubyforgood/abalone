# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: wild_collections
#
#  id                                         :bigint           not null, primary key
#  raw                                        :boolean          default(TRUE), not null
#  tag                                        :string
#  collection_date                            :date
#  general_location                           :string
#  precise_location                           :string
#  collection_coodinates                      :point
#  proximity_to_nearest_neighbor              :string
#  collection_method_notes                    :string
#  foot_condition_notes                       :string
#  collection_depth                           :decimal(, )
#  length                                     :decimal(, )
#  weight                                     :decimal(, )
#  gonad_score                                :string
#  predicted_sex                              :string
#  initial_holding_facility                   :string
#  final_holding_facility_and_date_of_arrival :string
#  otc_treatment_completion_date              :date
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  processed_file_id                          :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class WildCollection < ApplicationRecord
  include Raw

  HEADERS = {
    TAG: 'Tag',
    COLLECTION_DATE: 'Collection_date',
    GENERAL_LOCATION: 'General Location',
    PRECISE_LOCATION: 'Precise Location',
    COLLECTION_COODINATES: 'Collection_coodinates',
    PROXIMITY_TO_NEAREST_NEIGHBOR: 'Proximity to nearest neighbor (m)',
    COLLECTION_METHOD_NOTES: 'Collection method notes',
    FOOT_CONDITION_NOTES: 'Foot condition notes',
    COLLECTION_DEPTH: 'Collection_depth_(m)',
    LENGTH: 'Length',
    WEIGHT: 'Weight',
    GONAD_SCORE: 'Gonad Score',
    PREDICTED_SEX: 'Predicted Sex',
    INITIAL_HOLDING_FACILITY: 'Initial holding facility',
    FINAL_HOLDING_FACILITY_AND_DATE_OF_ARRIVAL: 'Final holding facility & date of arrival',
    OTC_TREATMENT_COMPLETION_DATE: 'OTC treatment completion date'
  }.freeze
end
