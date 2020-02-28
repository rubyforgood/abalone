# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: untagged_animal_assessments
#
#  id                :bigint           not null, primary key
#  raw               :boolean          default(TRUE), not null
#  measurement_date  :date
#  cohort            :string
#  spawning_date     :date
#  growout_rack      :decimal(, )
#  growout_column    :string
#  growout_trough    :decimal(, )
#  length            :decimal(, )
#  mass              :decimal(, )
#  gonad_score       :decimal(, )
#  predicted_sex     :string
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  processed_file_id :integer
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

class UntaggedAnimalAssessment < ApplicationRecord
  HEADERS = {
    MEASUREMENT_DATE: "Measurement_date",
    COHORT: "Cohort",
    SPAWNING_DATE: "Spawning_date",
    GROWOUT_RACK: "Growout_Rack",
    GROWOUT_COLUMN: "Growout_Column",
    GROWOUT_TROUGH: "Growout_Trough",
    LENGTH: "Length", # (mm)
    MASS: "Mass", # (g)
    GONAD_SCORE: "Gonad Score",
    PREDICTED_SEX: "Predicted Sex",
    NOTES: "Notes"
  }.freeze

  # this is used to dynamically define argument setter for these attributes
  DATE_ATTRIBUTES = %w[
    measurement_date
    spawning_date
  ].freeze

  validates(
    :measurement_date,
    :cohort,
    :spawning_date,
    :growout_trough,
    :growout_rack,
    :growout_column,
    :length, presence: true
  )
  validates :length, numericality: true

  def self.create_from_csv_data(attrs)
    new(attrs)
  end

  # Cohort is translated to shl_case_number to compute stats.
  # Here we need to transfer it back to be able to store value in the DB.
  def shl_case_number=(value)
    self.cohort = value
  end

  def shl_case_number
    cohort
  end

  DATE_ATTRIBUTES.each do |name|
    define_method "#{name}=" do |argument|
      return unless argument

      begin
        write_attribute(name.to_sym, DateTime.strptime(argument, "%m/%d/%y"))
      rescue ArgumentError
        errors.add(name.to_sym, :invalid, message: "Invalid date format: #{argument}")
      end
    end
  end

  def self.lengths_for_measurement(processed_file_id)
    select(:length).where(processed_file_id: processed_file_id).map { |record| record.length.to_f }
  end

  def cleanse_data!
    # Do nothing
  end
end
