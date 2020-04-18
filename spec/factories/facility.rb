FactoryBot.define do
  factory :facility do
    val = Faker::Name.unique.name
    name { val }
    code { val.gsub(/[aeiou|AEIOU|\s]+/, '').strip }
    organization_id { FactoryBot.create(:organization).id}
  end
end
