# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: processed_files
#
#  id                :bigint           not null, primary key
#  filename          :string
#  original_filename :string
#  category          :string
#  status            :string
#  job_stats         :jsonb            not null
#  job_errors        :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

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
