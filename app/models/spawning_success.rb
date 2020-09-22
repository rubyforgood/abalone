# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
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
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

class SpawningSuccess < ApplicationRecord
  include Raw

  HEADERS = {
    TAG: "Tag",
    SHL_CASE_NUMBER: "SHL_number",
    SPAWNING_DATE: "Spawning_date",
    DATE_ATTEMPTED: "Date_attempted",
    SPAWNING_SUCCESS: "Spawning_success",
    NUMBER_OF_EGGS_SPAWNED: "Number of eggs spawned (if female)"
  }.freeze

  validates :shl_case_number, presence: true

  def self.create_from_csv_data(attrs)
    attrs[:nbr_of_eggs_spawned] = attrs.delete(:number_of_eggs_spawned_if_female)
    attrs[:shl_case_number]     = attrs.delete(:shl_number)

    new(attrs.except(:organization_id))
  end

  # Note: Case is meaningful for spawning_success. n, Y and y mean different things.
  def cleanse_data!
    self.tag = tag.to_s&.strip&.upcase
    self.shl_case_number = shl_case_number.to_s&.strip&.upcase
  end
end
