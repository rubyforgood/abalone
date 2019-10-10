FactoryBot.define do
  factory :processed_file do
    filename { "MyString" }
    category { "MyString" }
    id { 1 }
    status { "MyString" }
    job_stats { "" }
    job_errors { "MyText" }
  end
end
