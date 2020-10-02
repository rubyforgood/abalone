# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: facilities
#
#  id         :bigint           not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

require 'rails_helper'

RSpec.describe Facility, type: :model do
  let(:facility) { FactoryBot.create :facility }

  it "Facility has associations" do
    is_expected.to have_many(:locations)
    is_expected.to belong_to(:organization)
  end

  describe 'structure' do
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :code }
    it { is_expected.to have_db_column :organization_id }

    describe 'it only has 6 columns' do
      it { expect(Facility.columns.count).to eq 6 }
    end
  end

  include_examples 'organization presence validation'
end
