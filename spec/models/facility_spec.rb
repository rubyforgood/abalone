require 'rails_helper'

RSpec.describe Facility, type: :model do
 let(:facility) { FactoryBot.create :facility }

 describe 'structure' do
   it { is_expected.to have_db_column :name }
   it { is_expected.to have_db_column :code }
 end
end
