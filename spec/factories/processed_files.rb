FactoryBot.define do
  factory :processed_file do
    filename { "MyString" }
    category { "MyString" }
    status { "MyString" }
    job_stats { "" }
    job_errors { "MyText" }
  end
end
