FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.hex}@test.com" }
    password { "password" }
    password_confirmation { "password" }
    organization

    trait(:as_admin)  { role { :admin } }
    trait(:as_user)   { role { :user } }
  end
end
