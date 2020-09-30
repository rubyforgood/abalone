FactoryBot.define do
  factory :animal do
    collection_year { 1 }
    date_time_collected { "2020-04-04 18:52:09" }
    collection_position { "MyString" }
    sequence(:tag) { |n| "G#{format('%<number>03d', number: n)}" }
    sex { Animal.sexes.keys.sample }
    organization

    factory(:male) { sex { 'male' } }
    factory(:female) { sex { 'female' } }
  end
end
