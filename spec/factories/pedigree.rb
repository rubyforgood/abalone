# frozen_string_literal: true

FactoryBot.define do
  factory :pedigree do
    cohort { Faker::Name.name }
    shl_case { "SF#{rand(0..9)}#{rand(0..9)}-#{rand(0..9)}#{rand(0..9)}" }
    spawning_date { Time.now }
    mother { Faker::Name.name }
    father { Faker::Name.name }
    seperate_cross_within_cohort { "F#{rand(0...1e3).to_i}xM#{rand(0...1e3).to_i}" }
  end
end
