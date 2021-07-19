FactoryBot.define do
  factory :enclosure do
    sequence(:name) { |n| "Enclosure #{n}" }
    location
    organization
  end
end
