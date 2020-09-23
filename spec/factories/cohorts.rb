FactoryBot.define do
  factory :cohort do
    female factory: :animal
    male factory: :animal
    organization
  end
end
