require 'rails_helper'

RSpec.describe MeasurementType, type: :model do
  subject(:measurement_type) { build_stubbed(:measurement_type) }

  it "has associations" do
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:measurements)
  end

  describe "Validations >" do
    subject(:measurement_type) { build(:measurement_type) }

    it "has a valid factory" do
      expect(measurement_type).to be_valid
    end

    include_examples OrganizationScope

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:unit) }
  end
end
