require 'rails_helper'

RSpec.describe Facility, type: :model do
 let(:facility) { FactoryBot.create :facility }

 describe 'structure' do
   it { is_expected.to have_db_column :name }
   it { is_expected.to have_db_column :code }

   describe 'it only has 5 columns' do
     it { expect(Facility.columns.count).to eq 5 }
   end
 end
end
