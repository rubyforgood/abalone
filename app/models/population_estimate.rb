# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: population_estimates
#
#  id                :bigint           not null, primary key
#  raw               :boolean          default(TRUE), not null
#  sample_date       :date
#  shl_case_number   :string
#  spawning_date     :date
#  lifestage         :string
#  abundance         :string
#  facility          :string
#  notes             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  processed_file_id :integer
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

class PopulationEstimate < ApplicationRecord
  include Raw

  HEADERS = {
    SAMPLE_DATE: "Sample_date",
    SHL_CASE_NUMBER: "SHL_number",
    SPAWNING_DATE: "Spawning_date",
    LIFESTAGE: "lifestage",
    ABUNDANCE: "abundance",
    FACILITY: "facility",
    NOTES: "Notes"
  }.freeze

  VALID_LIFESTAGES = %w[embryo embryos larvae juvenile adult].freeze

  validates :sample_date, :shl_case_number, :abundance, :facility, presence: true
  validates :abundance, numericality: true
  validate :facility_is_valid,
           :lifestage_is_valid

  def self.create_from_csv_data(attrs)
    attrs[:abundance] = attrs[:abundance].delete(',').to_i
    attrs[:shl_case_number] = attrs.delete(:shl_number)
    attrs[:sample_date] = Date.strptime(attrs[:sample_date], '%m/%d/%y') rescue nil
    attrs[:spawning_date] = Date.strptime(attrs[:spawning_date], '%m/%d/%y') rescue nil

    new(attrs)
  end

  def facility_is_valid
    return if facility.blank?
    return if Facility.valid_code?(facility)

    errors.add(:initial_holding_facility, "#{facility} does not match the code for any known facility")
  end

  def lifestage_is_valid
    return if lifestage.blank?
    return if VALID_LIFESTAGES.include?(lifestage)

    errors.add(:lifestage, "#{lifestage} does not match the valid lifestages: embryos, larvae, juvenile, or adult")
  end
end
