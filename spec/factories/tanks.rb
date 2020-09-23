FactoryBot.define do
  factory :tank do
    sequence(:name) { |n| "MyString#{n}" }
    facility
    organization
  end
end
