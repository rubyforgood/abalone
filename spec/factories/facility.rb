FactoryBot.define do
  factory :facility do
    name { "#{Faker::Games::HalfLife.location}" }
    code { name.gsub(/[^A-Z]/, '') }
    organization
  end
end
