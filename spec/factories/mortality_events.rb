FactoryBot.define do
  factory :mortality_event do
    cohort
    animal
    organization

    trait :for_cohort do
      animal { nil }
    end
  end
end
