FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.hex}@test.com" }
    password { "password" }
    password_confirmation { "password" }
    organization
  end
end
