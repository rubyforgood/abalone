# frozen_string_literal: true

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
end
