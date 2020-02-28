# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: untagged_animal_assessments
#
#  id                :bigint           not null, primary key
#  raw               :boolean          default(TRUE), not null
#  measurement_date  :date
#  cohort            :string
#  spawning_date     :date
#  growout_rack      :decimal(, )
#  growout_column    :string
#  growout_trough    :decimal(, )
#  length            :decimal(, )
#  mass              :decimal(, )
#  gonad_score       :decimal(, )
#  predicted_sex     :string
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  processed_file_id :integer
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

FactoryBot.define do
  factory :untagged_animal_assessment do
  end
end
