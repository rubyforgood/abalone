FactoryBot.define do
  factory :measurement do
    name { "MyString" }
    value_type { "MyString" }
    value { "" }
    tank { nil }
  end
end
