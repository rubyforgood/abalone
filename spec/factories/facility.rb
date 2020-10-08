FactoryBot.define do
  factory :facility do
    val = Faker::Name.unique.name
    name { val }
    sequence :code do |idx|
      "#{val.gsub(/[aeiou|AEIOU|\s]+/, '').strip}-#{idx}"
    end
    organization
  end
end
