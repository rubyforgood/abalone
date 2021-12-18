require 'rails_helper'

RSpec.describe MeasurementType, type: :model do
  subject(:measurement_type) { build_stubbed(:measurement_type) }

  describe "Associations >" do
    it "has associations" do
      is_expected.to belong_to(:organization)
      is_expected.to have_many(:measurements)
    end

    context "with an associated measurement" do
      subject(:measurement_type) { create(:measurement_type) }

      before do
        create(:measurement, measurement_type: measurement_type)
      end

      it "cannot be destroyed" do
        expect { measurement_type.destroy }
          .not_to change(MeasurementType, :count)
      end

      it "adds an error to the measurement_type" do
        measurement_type.destroy
        expect(measurement_type.errors.full_messages)
          .to eq(["Cannot delete record because dependent measurements exist"])
      end
    end
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
