# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: mortality_trackings
#
#  id                :bigint           not null, primary key
#  raw               :boolean          default(TRUE), not null
#  mortality_date    :date
#  cohort            :string
#  shl_case_number   :string
#  spawning_date     :date
#  shell_box         :integer
#  shell_container   :string
#  animal_location   :string
#  number_morts      :integer
#  approximation     :string
#  processed_by_shl  :string
#  initials          :string
#  tags              :string
#  comments          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  processed_file_id :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

require 'rails_helper'

RSpec.describe MortalityTracking, type: :model do
  let(:mortality_tracking) { FactoryBot.create :mortality_tracking }

  let(:valid_attributes) do
    {
      raw: true,
      mortality_date: '1/1/19',
      cohort: 'UCSB 2012',
      shl_case_number: 'SF08-26',
      spawning_date: '5/1/19',
      shell_box: 'SHL',
      shell_container: 'Loose',
      animal_location: '',
      number_morts: 2,
      approximation: '',
      processed_by_shl: 'N',
      initials: 'LA',
      tags: 'Green_232 Yellow_222',
      comments: 'Too degraded to process'
    }
  end

  describe 'structure' do
    it { is_expected.to have_db_column :raw }
    it { is_expected.to have_db_column :mortality_date }
    it { is_expected.to have_db_column :cohort }
    it { is_expected.to have_db_column :shl_case_number }
    it { is_expected.to have_db_column :spawning_date }
    it { is_expected.to have_db_column :shell_box }
    it { is_expected.to have_db_column :shell_container }
    it { is_expected.to have_db_column :animal_location }
    it { is_expected.to have_db_column :number_morts }
    it { is_expected.to have_db_column :approximation }
    it { is_expected.to have_db_column :processed_by_shl }
    it { is_expected.to have_db_column :initials }
    it { is_expected.to have_db_column :tags }
    it { is_expected.to have_db_column :comments }

    describe 'it only has 18 columns' do
      it { expect(MortalityTracking.columns.count).to eq 18 }
    end
  end

  include_examples 'a required field', :mortality_date
  include_examples 'a required field', :cohort
  include_examples 'a required field', :shl_case_number
  include_examples 'a required field', :spawning_date
  include_examples 'a required field', :number_morts

  include_examples 'an optional field', :shell_box
  include_examples 'an optional field', :shell_container
  include_examples 'an optional field', :animal_location
  include_examples 'an optional field', :approximation
  include_examples 'an optional field', :processed_by_shl
  include_examples 'an optional field', :initials
  include_examples 'an optional field', :tags
  include_examples 'an optional field', :comments

  describe 'raw' do
    include_examples 'validate values for field', :raw do
      let(:valid_values) do
        [true, false]
      end

      let(:invalid_values) do
        [nil]
      end
    end
  end

  describe 'processed by shl' do
    include_examples 'validate values for field', :processed_by_shl do
      let(:valid_values) do
        %w[Y N]
      end

      let(:invalid_values) do
        %w[Z]
      end
    end
  end

  describe '#mortality_date=' do
    subject do
      model = described_class.new
      model.mortality_date = mortality_date_str
      model.mortality_date
    end

    context 'when the mortality_date is not in the correct format' do
      let(:mortality_date_str) { 'not-a-valid-date' }

      it 'should set the mortality_date to nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'when the mortality_date is not in the correct format' do
      let(:mortality_date_str) { '4/10/20' }

      it 'should set the mortality_date to a DateTime' do
        expect(subject).to be_a_kind_of(Date)
      end
    end
  end

  describe '#spawning_date=' do
    subject do
      model = described_class.new
      model.spawning_date = spawning_date_str
      model.spawning_date
    end

    context 'when the spawning_date is not in the correct format' do
      let(:spawning_date_str) { 'not-a-valid-date' }

      it 'should set the spawning_date to nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'when the mortality_date is not in the correct format' do
      let(:spawning_date_str) { '4/10/20' }

      it 'should set the spawning_date to a DateTime' do
        expect(subject).to be_a_kind_of(Date)
      end
    end
  end

end
