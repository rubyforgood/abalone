FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    facility
    organization

    trait :with_enclosures do
      transient { enclosures_count { 1 } }

      after(:create) do |location, eval|
        create_list :enclosure, eval.enclosures_count, location: location
        location.reload
      end
    end
  end
end
