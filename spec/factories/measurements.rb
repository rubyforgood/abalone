FactoryBot.define do
  factory :measurement do
    value { "" }
    measurement_type
    association :subject, factory: :enclosure
    measurement_event
    organization
  end
end
