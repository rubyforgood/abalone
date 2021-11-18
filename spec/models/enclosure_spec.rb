require 'rails_helper'

RSpec.describe Enclosure, type: :model do
  subject(:enclosure) { build_stubbed(:enclosure) }

  it "has associations" do
    is_expected.to belong_to(:location).optional
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:measurements)
  end

  describe "Validations >" do
    subject(:enclosure) { build(:enclosure) }

    it "has a valid factory" do
      expect(enclosure).to be_valid
    end

    it_behaves_like OrganizationScope

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:organization_id, :location_id) }
  end

  describe "#empty?" do
    it "returns false with a cohort" do
      enclosure.cohort = build(:cohort)
      expect(enclosure).not_to be_empty
    end

    it "returns true without a cohort" do
      expect(enclosure).to be_empty
    end
  end
end
