# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: tagged_animal_assessments
#
#  id                  :bigint           not null, primary key
#  raw                 :boolean          default(TRUE), not null
#  measurement_date    :date
#  shl_case_number     :string
#  spawning_date       :date
#  tag                 :string
#  from_growout_rack   :string
#  from_growout_column :string
#  from_growout_trough :string
#  to_growout_rack     :string
#  to_growout_column   :string
#  to_growout_trough   :string
#  length              :decimal(, )
#  gonad_score         :string
#  predicted_sex       :string
#  notes               :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  processed_file_id   :integer
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

FactoryBot.define do
  factory :tagged_animal_assessment do
    raw { false }
    measurement_date { "09/20/18" }
    shl_case_number { "SF16-9D" }
    spawning_date { "03/02/16" }
    tag { "Lav_203" }
    from_growout_rack { "3" }
    from_growout_column { "B" }
    from_growout_trough { "3" }
    to_growout_rack { "1" }
    to_growout_column { "A" }
    to_growout_trough { "2" }
    length { 0.438e2 }
    gonad_score { "1" }
    predicted_sex { "M" }
    notes { nil }
    processed_file_id { 1 }
  end
end
