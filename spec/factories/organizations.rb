FactoryBot.define do
  factory :organization do
    name { Faker::Name.unique.name }
  end
end
