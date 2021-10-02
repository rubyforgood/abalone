FactoryBot.define do
  factory :animal do
    entry_year { 1 }
    entered_at { "2020-04-04 18:52:09" }
    entry_point { "MyString" }
    collected { true }
    sequence(:tag) { |n| "G#{format('%<number>03d', number: n)}" }
    sex { Animal.sexes.keys.sample }
    organization

    factory(:male) { sex { 'male' } }
    factory(:female) { sex { 'female' } }
  end
end
