FactoryBot.define do
  factory :animal do
    collection_year { 1 }
    date_time_collected { "2020-04-04 18:52:09" }
    collection_position { "MyString" }
    pii_tag { 1 }
    tag_id { 1 }
    sex { Animal.sexes.keys.sample }
    organization
  end
end
