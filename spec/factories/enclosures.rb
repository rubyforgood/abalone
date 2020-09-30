FactoryBot.define do
  factory :enclosure do
    sequence(:name) { |n| "MyString#{n}" }
    location
    organization
    cohort
  end
end
