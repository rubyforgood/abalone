FactoryBot.define do
  factory :facility do
    val = Faker::Name.unique.name
    name { val }
    code { val.gsub(/[aeiou|AEIOU|\s]+/, '').strip }
  end
end
