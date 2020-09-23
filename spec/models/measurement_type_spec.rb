require 'rails_helper'

RSpec.describe MeasurementType, type: :model do
  it "Measurement type has associations" do
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:measurements)
  end
end
