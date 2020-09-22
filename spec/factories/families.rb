FactoryBot.define do
  factory :family do
    female factory: :animal
    male factory: :animal
    organization
  end
end
