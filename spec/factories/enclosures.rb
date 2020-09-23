FactoryBot.define do
  factory :enclosure do
    sequence(:name) { |n| "MyString#{n}" }
    facility
    organization
  end
end
