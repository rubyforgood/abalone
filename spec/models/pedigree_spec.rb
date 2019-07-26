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
  end
end
