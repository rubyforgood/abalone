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

FactoryBot.define do
  factory :population_estimate do
    sample_date { Time.now }
    shl_case_number { "SF#{rand(0..9)}#{rand(0..9)}-#{rand(0..9)}#{rand(0..9)}" }
    spawning_date { Time.now -5.days }
    lifestage { %w[y n].sample }
    abundance { rand(0..3000) }
    facility { (create :facility).code }
    notes { Faker::Team.name }
  end
end
