# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: pedigrees
#
#  id                           :bigint           not null, primary key
#  raw                          :boolean          default(TRUE), not null
#  cohort                       :string
#  shl_case_number              :string
#  spawning_date                :date
#  mother                       :string
#  father                       :string
#  seperate_cross_within_cohort :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  processed_file_id            :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class Pedigree < ApplicationRecord
  include Raw

  HEADERS = {
    COHORT: 'Cohort',
    SHL_CASE_NUMBER: 'SHL Case #',
    SPAWNING_DATE: 'Spawning date',
    MOTHER: 'Mother',
    FATHER: 'Father',
    SEPERATE_CROSS_WITHIN_COHORT: 'Separate crosses within cohort (F = female, M=male)'
  }.freeze
end
