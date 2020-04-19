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

require 'rails_helper'

RSpec.describe UntaggedAnimalAssessment, type: :model do
  describe 'validations' do
    it {
      should validate_presence_of(:measurement_date)
        .with_message("must be in the mm/dd/yy format")
    }
    it {
      should validate_presence_of(:spawning_date)
        .with_message("must be in the mm/dd/yy format")
    }

    it { should validate_presence_of(:cohort) }
    it { should validate_presence_of(:growout_trough) }
    it { should validate_presence_of(:growout_rack) }
    it { should validate_presence_of(:growout_column) }
    it { should validate_presence_of(:length) }

    it { should validate_numericality_of(:length) }
  end

  context 'if measurement_date is not in the mm/dd/yy format' do
    it 'is invalid' do
      assessment = build(:untagged_animal_assessment, measurement_date: "09/08/2019")
      expect { assessment.save! }.to raise_error ActiveRecord::RecordInvalid
      expect(assessment.errors[:measurement_date][0]).to eq("must be in the mm/dd/yy format")
    end

    it 'is invalid' do
      assessment = FactoryBot.create(:untagged_animal_assessment)
      assessment.measurement_date = "invalid"
      expect { assessment.save! }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
