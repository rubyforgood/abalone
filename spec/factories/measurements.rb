FactoryBot.define do
  factory :measurement do
    value { "25" }
    measurement_type
    association :subject, factory: :animal
    measurement_event
    organization

    # Polymorphic associations for measurements
    trait(:for_cohort)    { association :subject, factory: :cohort }
    trait(:for_enclosure) { association :subject, factory: :enclosure }
    trait(:for_animal)    { association :subject, factory: :animal }
  end
end
