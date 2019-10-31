# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: tagged_animal_assessments
#
#  id                  :bigint           not null, primary key
#  raw                 :boolean          default(TRUE), not null
#  measurement_date    :date
#  shl_case_number     :string
#  spawning_date       :date
#  tag                 :string
#  from_growout_rack   :string
#  from_growout_column :string
#  from_growout_trough :string
#  to_growout_rack     :string
#  to_growout_column   :string
#  to_growout_trough   :string
#  length              :decimal(, )
#  gonad_score         :string
#  predicted_sex       :string
#  notes               :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  processed_file_id   :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class TaggedAnimalAssessment < ApplicationRecord
  include Raw

  HEADERS = {
    MEASUREMENT_DATE: 'Measurement_date',
    SHL_CASE_NUMBER: 'SHL_case_number',
    SPAWNING_DATE: 'Spawning_date',
    TAG: 'Tag',
    FROM_GROWOUT_RACK: 'From_Growout_Rack',
    FROM_GROWOUT_COLUMN: 'From_Growout_Column',
    FROM_GROWOUT_TROUGH: 'From_Growout_Trough',
    TO_GROWOUT_RACK: 'To_Growout_Rack',
    TO_GROWOUT_COLUMN: 'To_Growout_Column',
    TO_GROWOUT_TROUGH: 'To_Growout_Trough',
    LENGTH: 'Length',
    GONAD_SCORE: 'Gonad_Score',
    PREDICTED_SEX: 'Predicted_Sex',
    NOTES: 'Notes'
  }.freeze

  validates :measurement_date, :shl_case_number, :spawning_date, :tag, :length, presence: true
  validates :length, numericality: true

  def measurement_date=(measurement_date_str)
    return unless measurement_date_str

    write_attribute(:measurement_date, DateTime.strptime(measurement_date_str, '%m/%d/%y'))
  end

  def spawning_date=(spawning_date_str)
    return unless spawning_date_str

    write_attribute(:spawning_date, DateTime.strptime(spawning_date_str, '%m/%d/%y'))
  end

  def self.lengths_for_measurement(processed_file_id)
    select(:length).where(processed_file_id: processed_file_id).map { |record| record.length.to_f }
  end

  def cleanse_data!
    # Do nothing
  end
end
