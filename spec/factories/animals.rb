FactoryBot.define do
  factory :animal do
    collection_year { 1 }
    date_time_collected { "2020-04-04 18:52:09" }
    collection_position { "MyString" }
    sequence(:tag) { |n| "G#{n}" }
    sex { Animal.sexes.keys.sample }
    organization
    cohort
  end
  factory :male, class: Animal do
    collection_year { 1 }
    date_time_collected { "2020-04-04 18:52:09" }
    collection_position { "MyString" }
    sequence(:tag) { |n| "Y#{n}" }
    sex { 'male' }
    organization
  end
  factory :female, class: Animal do
    collection_year { 1 }
    date_time_collected { "2020-04-04 18:52:09" }
    collection_position { "MyString" }
    sequence(:tag) { |n| "R#{n}" }
    sex { 'female' }
    organization
  end
end
