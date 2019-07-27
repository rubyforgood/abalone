FactoryBot.define do
  factory :population_estimate do
    sample_date {Time.now}
    shl_case_number { "SF#{rand(0..9)}#{rand(0..9)}-#{rand(0..9)}#{rand(0..9)}" }
    spawning_date {Time.now -5.days}
    lifestage { %w[y n].sample }
    abundance { rand(0..3000) }
    facility { (create :facility).code }
    notes { Faker::Team.name}
  end
end
