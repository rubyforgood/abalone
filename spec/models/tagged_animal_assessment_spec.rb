# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
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
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

require 'rails_helper'

RSpec.describe TaggedAnimalAssessment, type: :model do
  let(:valid_attributes) do
    {
      raw: false,
      measurement_date: Time.now.strftime('%D'),
      shl_case_number: 'SF16-9D',
      spawning_date: 5.days.ago.strftime('%D'),
      tag: 'Lav_203',
      from_growout_rack: '3',
      from_growout_column: 'B',
      from_growout_trough: '3',
      to_growout_rack: '1',
      to_growout_column: 'A',
      to_growout_trough: '2',
      length: 2.5,
      gonad_score: '1',
      predicted_sex: 'M'
    }
  end

  describe 'validations' do
    it { should validate_presence_of(:measurement_date).
          with_message("must be in the mm/dd/yy format") }
    it { should validate_presence_of(:spawning_date).
          with_message("must be in the mm/dd/yy format") }

    it { should validate_presence_of(:shl_case_number) }
    it { should validate_presence_of(:tag) }
    it { should validate_presence_of(:length) }

    it { should validate_numericality_of(:length).is_less_than(100) }
  end

  describe 'gonad score' do
    include_examples 'validate values for field', :gonad_score do
      let(:valid_values) do
        [
          '0', '1', '2', '3',
          '0?', '1?', '2?', '3?',
          '0-1', '0-1?', '0-2', '0-2?', '0-3', '0-3?',
          '1-2', '1-2?', '1-3', '1-3?',
          '2-3', '2-3?',
          'NA'
        ]
      end

      let(:invalid_values) do
        ['a', '4', '-2', '?']
      end
    end
  end

  describe 'predicted sex' do
    include_examples 'validate values for field', :predicted_sex do
      let(:valid_values) do
        %w[M F M? F?]
      end

      let(:invalid_values) do
        ['a', 'N', '4', '?']
      end
    end
  end

  describe 'shl case number' do
    include_examples 'validate values for field', :shl_case_number do
      let(:valid_values) do
        %w[SF10-3D, SF10-10, SF1D-10]
      end

      let(:invalid_values) do
        %w[SX10-10, XS10-10, 5]
      end
    end
  end

  context 'if measurement_date is not in the mm/dd/yy format' do
    it 'is invalid' do
      assessment = build(:tagged_animal_assessment, measurement_date: "09/08/2019")
      expect { assessment.save! }.to raise_error ActiveRecord::RecordInvalid
      expect(assessment.errors[:measurement_date][0]).to eq("must be in the mm/dd/yy format")
    end

    it 'is invalid' do
      assessment = build(:tagged_animal_assessment, measurement_date: "99/99/99")
      expect { assessment.save! }.to raise_error ActiveRecord::RecordInvalid
      expect(assessment.errors[:measurement_date][0]).to eq("must be in the mm/dd/yy format")
    end

    it 'is invalid' do
      assessment = FactoryBot.create(:tagged_animal_assessment)
      assessment.measurement_date = "invalid"
      expect { assessment.save! }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
