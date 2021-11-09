require 'rails_helper'

RSpec.describe Location, type: :model do
  subject(:location) { build_stubbed(:location) }

  it "has associations" do
    is_expected.to have_many(:enclosures)
    is_expected.to belong_to(:facility)
  end

  describe "Validations >" do
    subject(:location) { build_stubbed(:location) }

    it "has a valid factory" do
      expect(location).to be_valid
    end

    include_examples OrganizationScope

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:facility_id) }
  end

  describe "#name_with_facility" do
    before do
      location.name = "best location"
      location.facility.name = "best facility"
    end

    it "returns the name of the location combined with the name of the facility" do
      expect(location.name_with_facility).to eq("best facility - best location")
    end
  end
end
