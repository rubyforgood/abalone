require 'rails_helper'

RSpec.describe SpawningSuccess, type: :model do
  let(:spawning_success) { FactoryBot.create :spawning_success }

  describe 'structure' do
    it { is_expected.to have_db_column :tag }
    it { is_expected.to have_db_column :shl_case_number }
    it { is_expected.to have_db_column :spawning_date }
    it { is_expected.to have_db_column :date_attempted }
    it { is_expected.to have_db_column :spawning_success }
    it { is_expected.to have_db_column :nbr_of_eggs_spawned }

    describe 'it only has 10 columns' do
      it { expect(SpawningSuccess.columns.count).to eq 10 }
    end
  end
end
