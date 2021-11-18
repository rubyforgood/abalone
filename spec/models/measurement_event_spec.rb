require 'rails_helper'

RSpec.describe MeasurementEvent, type: :model do
  subject(:measurement_event) { build_stubbed(:measurement_event) }

  it "has associations" do
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
  end

  describe "Validations >" do
    subject(:measurement_event) { build(:measurement_event) }

    it "has a valid factory" do
      expect(measurement_event).to be_valid
    end

    include_examples OrganizationScope
  end
end
