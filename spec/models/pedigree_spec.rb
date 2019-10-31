# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: pedigrees
#
#  id                           :bigint           not null, primary key
#  raw                          :boolean          default(TRUE), not null
#  cohort                       :string
#  shl_case_number              :string
#  spawning_date                :date
#  mother                       :string
#  father                       :string
#  seperate_cross_within_cohort :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  processed_file_id            :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

require 'rails_helper'

RSpec.describe Pedigree, type: :model do
  let(:pedigree) { FactoryBot.create :pedigree }

  describe 'structure' do
    it { is_expected.to have_db_column :raw }
    it { is_expected.to have_db_column :cohort }
    it { is_expected.to have_db_column :shl_case_number }
    it { is_expected.to have_db_column :spawning_date }
    it { is_expected.to have_db_column :mother }
    it { is_expected.to have_db_column :father }
    it { is_expected.to have_db_column :seperate_cross_within_cohort }

    describe 'it only has 10 columns' do
      it { expect(Pedigree.columns.count).to eq 11 }
    end
  end
end
