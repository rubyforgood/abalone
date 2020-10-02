require 'rails_helper'

RSpec.describe Location, type: :model do
  it "Location has associations" do
    is_expected.to have_many(:enclosures)
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:facility)
  end

  describe ".name_with_facility" do
    it "returns the name of the location combined with the name of the facility" do
      location = create :location
      expect(location.name_with_facility).to eq "#{location.facility_name} - #{location.name}"
    end
  end

  include_examples 'organization presence validation' do
    let(:model) { described_class.new name: 'Name of location', facility: create(:facility), organization: organization }
  end
end
