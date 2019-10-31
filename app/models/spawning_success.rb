# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: spawning_successes
#
#  id                  :bigint           not null, primary key
#  raw                 :boolean          default(TRUE), not null
#  tag                 :string
#  shl_case_number     :string
#  spawning_date       :date
#  date_attempted      :date
#  spawning_success    :string
#  nbr_of_eggs_spawned :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  processed_file_id   :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class SpawningSuccess < ApplicationRecord
  include Raw

  HEADERS = {
    TAG: 'Tag',
    SHL_CASE_NUMBER: 'SHL Case Number',
    SPAWNING_DATE: 'Spawning_date',
    DATE_ATTEMPTED: 'Date_attempted',
    SPAWNING_SUCCESS: 'Spawning_success',
    NUMBER_OF_EGGS_SPAWNED: 'Number of eggs spawned (if female)'
  }.freeze

  validates :shl_case_number, presence: true

  # Note: Case is meaningful for spawning_success. n, Y and y mean different things.
  def cleanse_data!
    self.tag = tag.to_s&.strip&.upcase
    self.shl_case_number = shl_case_number.to_s&.strip&.upcase
  end
end
