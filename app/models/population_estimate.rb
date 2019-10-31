# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
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
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class PopulationEstimate < ApplicationRecord
  include Raw

  HEADERS = {
    SAMPLE_DATE: 'Sample_date',
    SHL_CASE_NUMBER: 'SHL Case Number',
    SPAWNING_DATE: 'Spawning_date',
    LIFESTAGE: 'lifestage',
    ABUNDANCE: 'abundance',
    FACILITY: 'facility',
    NOTES: 'Notes'
  }.freeze
end
