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

FactoryBot.define do
  factory :wild_collection do
  end
end
