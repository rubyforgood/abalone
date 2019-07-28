require 'rails_helper'

RSpec.describe PopulationEstimate, type: :model do
  let(:population_estimate) { FactoryBot.create :population_estimate }

  describe 'structure' do
    it { is_expected.to have_db_column :sample_date }
    it { is_expected.to have_db_column :shl_case_number }
    it { is_expected.to have_db_column :spawning_date }
    it { is_expected.to have_db_column :lifestage }
    it { is_expected.to have_db_column :abundance }
    it { is_expected.to have_db_column :facility }
    it { is_expected.to have_db_column :notes }

    describe 'it only has 11 columns' do
      it { expect(PopulationEstimate.columns.count).to eq 12 }
    end
  end
end
