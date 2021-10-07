FactoryBot.define do
  factory :animal do
    entry_year { 1 }
    entry_date { "2020-04-04 18:52:09" }
    entry_point { "" }
    sequence(:tag) { |n| "G#{format('%<number>03d', number: n)}" }
    sex { Animal.sexes.keys.sample }
    collected { false }
    organization

    factory(:male) { sex { 'male' } }
    factory(:female) { sex { 'female' } }
  end
end
