# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: mortality_trackings
#
#  id                :bigint           not null, primary key
#  raw               :boolean          default(TRUE), not null
#  mortality_date    :date
#  cohort            :string
#  shl_case_number   :string
#  spawning_date     :date
#  shell_box         :integer
#  shell_container   :string
#  animal_location   :string
#  number_morts      :integer
#  approximation     :string
#  processed_by_shl  :string
#  initials          :string
#  tags              :string
#  comments          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  processed_file_id :integer
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

class MortalityTracking < ApplicationRecord
  include Raw

  HEADERS = {
    MORTALITY_DATE: "Mortality_date",
    COHORT: "Cohort",
    SHL_CASE_NUMBER: "SHL number",
    SPAWNING_DATE: "Spawning_date",
    SHELL_BOX: "Shell_box",
    SHELL_CONTAINER: "Shell_container",
    ANIMAL_LOCATION: "Animal_location",
    NUMBER_MORTS: "\# Morts",
    APPROXIMATION: "Approximation?",
    PROCESSED_BY_SHL: "Processed by SHL?",
    INITIALS: "Initials",
    TAGS: "Tag(s)",
    COMMENTS: "Comments"
  }.freeze

  def self.create_from_csv_data(attrs)
    attrs[:shl_case_number] = attrs.delete(:shl_number)
    attrs[:number_morts] = attrs.delete(:morts)
    # Attempt to convert provided csv attributes
    # to the proper format. Dates are provided as
    # strings and must be converted to a datetime.
    #
    # Note - DateTime.strptime will raise a ArgumentError
    # if there is a issue converting.
    attrs[:spawning_date] = DateTime.strptime(attrs.delete(:spawning_date), '%m/%d/%y')
    attrs[:mortality_date] = DateTime.strptime(attrs.delete(:mortality_date), '%m/%d/%y')

    new(attrs)
  end

  validates_presence_of :shl_case_number
end
