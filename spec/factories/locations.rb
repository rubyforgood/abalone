FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    facility
    organization

    trait :with_enclosures do
      transient { enclosures_count { 5 } }

      after(:create) do |loc, eval|
        create_list :enclosure, eval.enclosures_count, location: loc
        loc.reload
      end
    end
  end
end
