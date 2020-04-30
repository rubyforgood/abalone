FactoryBot.define do
  factory :measurement do
    name { "MyString" }
    value_type { "MyString" }
    value { "" }
    measurement_event
  end
end
