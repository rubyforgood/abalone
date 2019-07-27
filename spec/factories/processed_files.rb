FactoryBot.define do
  factory :processed_file do
    filename { "MyString" }
    category { "MyString" }
    job_id { 1 }
    status { "MyString" }
    job_stats { "" }
    errors { "MyText" }
  end
end
