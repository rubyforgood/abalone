# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
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
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

require 'rails_helper'

RSpec.describe UntaggedAnimalAssessment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:measurement_date) }
    it { should validate_presence_of(:cohort) }
    it { should validate_presence_of(:spawning_date) }
    it { should validate_presence_of(:growout_trough) }
    it { should validate_presence_of(:growout_rack) }
    it { should validate_presence_of(:growout_column) }
    it { should validate_presence_of(:length) }

    it { should validate_numericality_of(:length) }
  end
end
