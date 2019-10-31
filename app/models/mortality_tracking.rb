# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
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
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class MortalityTracking < ApplicationRecord
  include Raw

  HEADERS = {
    MORTALITY_DATE: 'Mortality_date',
    COHORT: 'Cohort',
    SHL_CASE_NUMBER: 'SHL number',
    SPAWNING_DATE: 'Spawning_date',
    SHELL_BOX: 'Shell_box',
    SHELL_CONTAINER: 'Shell_container',
    ANIMAL_LOCATION: 'Animal_location',
    NUMBER_MORTS: "\# Morts",
    APPROXIMATION: 'Approximation?',
    PROCESSED_BY_SHL: 'Processed by SHL?',
    INITIALS: 'Initials',
    TAGS: 'Tag(s)',
    COMMENTS: 'Comments'
  }.freeze
end
