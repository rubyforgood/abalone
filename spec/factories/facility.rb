FactoryBot.define do
  factory :facility do
    name { Faker::Games::HalfLife.location.to_s }
    code { name.gsub(/[^A-Z]/, '') }
    organization
  end
end
