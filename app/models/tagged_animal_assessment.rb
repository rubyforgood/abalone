# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
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
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

class TaggedAnimalAssessment < ApplicationRecord
  include Raw

  HEADERS = {
    MEASUREMENT_DATE: "Measurement_date",
    SHL_CASE_NUMBER: "SHL_case_number",
    SPAWNING_DATE: "Spawning_date",
    TAG: "Tag",
    FROM_GROWOUT_RACK: "From_Growout_Rack",
    FROM_GROWOUT_COLUMN: "From_Growout_Column",
    FROM_GROWOUT_TROUGH: "From_Growout_Trough",
    TO_GROWOUT_RACK: "To_Growout_Rack",
    TO_GROWOUT_COLUMN: "To_Growout_Column",
    TO_GROWOUT_TROUGH: "To_Growout_Trough",
    LENGTH: "Length",
    GONAD_SCORE: "Gonad_Score",
    PREDICTED_SEX: "Predicted_Sex",
    NOTES: "Notes"
  }.freeze

  # this is used to dynamically define argument setter for these attributes
  DATE_ATTRIBUTES = %w[
    measurement_date
    spawning_date
  ].freeze

  validates :measurement_date, :spawning_date, presence: { message: "must be in the mm/dd/yy format" }
  validates :shl_case_number, :tag, :length, presence: true
  validates :shl_case_number, format: { with: /SF[\w\d]{2}-[\w\d]{2}/ }, allow_blank: true
  validates :gonad_score, format: { with: /\A(?:(?:NA)|(?:[0-3](?:-[13])?\??))/ }, allow_blank: true
  validates :predicted_sex, format: { with: /\A[MF]\??/ }, allow_blank: true
  validates_numericality_of :length, less_than: 100

  def self.create_from_csv_data(attrs)
    new(attrs)
  end

  DATE_ATTRIBUTES.each do |name|
    define_method "#{name}=" do |argument|
      return unless argument

      parsed_date = DateParser.parse(argument)
      write_attribute(name.to_sym, parsed_date)
    end
  end

  def self.lengths_for_measurement(shl_case_number, measurement_date)
    measurements = select(:length)
                   .where(shl_case_number: shl_case_number)
                   .where(measurement_date: measurement_date)

    # group by bin (1cm). need constant of bins
    grouped_measurements = measurements.group_by { |record| record.length.to_i }

    # count = count of all animals from that spreadsheet
    sample = measurements.count.to_f

    [grouped_measurements, sample]
  end

  def cleanse_data!
    # Do nothing
  end
end
