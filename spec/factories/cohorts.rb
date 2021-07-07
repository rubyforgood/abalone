FactoryBot.define do
  factory :cohort do
    female factory: :female
    male factory: :male
    enclosure
    organization
    name { Faker::Name.unique.name }
  end
end
