# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
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
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

class WildCollection < ApplicationRecord
  include Raw

  # Keys in HEADERS hash match database column names
  # Values match csv file column names
  HEADERS = {
    TAG: "Tag",
    COLLECTION_DATE: "Collection_date",
    GENERAL_LOCATION: "General Location",
    PRECISE_LOCATION: "Precise Location",
    COLLECTION_COORDINATES: "Collection_coodinates",
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
  }.freeze

  validates :tag, presence: true
  validates :collection_date, presence: true
  validates :general_location, presence: true
  validates :precise_location, presence: true
  validates :collection_coordinates, presence: true
  validates :initial_holding_facility, presence: true

  validates :collection_depth, numericality: true, allow_blank: true
  validates :length, numericality: true, allow_blank: true
  validates :weight, numericality: true, allow_blank: true

  validates :gonad_score, format: { with: /\A(?:(?:NA)|(?:[0-3](?:-[13])?\??))/ }, allow_blank: true
  validates :predicted_sex, format: { with: /\A[MF]\??/ }, allow_blank: true

  validate :initial_holding_facility_is_valid,
           :final_facility_and_date_of_arrival_is_valid

  def self.create_from_csv_data(attrs)
    attrs[:proximity_to_nearest_neighbor]              = attrs.delete(:proximity_to_nearest_neighbor_m)
    attrs[:collection_depth]                           = attrs.delete(:collection_depth_m)
    attrs[:collection_coordinates]                     = attrs.delete(:collection_coodinates)
    attrs[:final_holding_facility_and_date_of_arrival] = attrs.delete(:final_holding_facility_date_of_arrival)
    attrs[:collection_date] = Date.strptime(attrs[:collection_date], '%m/%d/%y') rescue nil
    attrs[:otc_treatment_completion_date] = Date.strptime(attrs[:otc_treatment_completion_date], '%m/%d/%y') rescue nil

    new(attrs)
  end

  def initial_holding_facility_is_valid
    return if initial_holding_facility.blank?
    return if Facility.valid_code?(initial_holding_facility)

    errors.add(:initial_holding_facility, "#{initial_holding_facility} does not match the code for any known facility")
  end

  def final_facility_and_date_of_arrival_is_valid
    return if final_holding_facility_and_date_of_arrival.blank?

    matches = /\A(?<facility>[A-Za-z ]+);\s*(?<date>.+)\z/.match(final_holding_facility_and_date_of_arrival)

    if matches.nil?
      errors.add(:final_holding_facility_and_date_of_arrival, "could not parse #{final_holding_facility_and_date_of_arrival}")

      return
    end

    unless Facility.valid_code?(matches[:facility])
      errors.add(:final_holding_facility_and_date_of_arrival, "#{matches[:facility]} does not match the code for any known facility")
    end

    Date.strptime(matches[:date], '%m/%d/%y')
  rescue ArgumentError => e
    raise e unless e.message == 'invalid date'

    errors.add(:final_holding_facility_and_date_of_arrival, "#{matches[:date]} could not be parsed as a valid date")
  end

  def cleanse_data!; end

  def collection_coordinates=(value)
    value = nil if value == 'redacted'

    super(value)
  end
end
