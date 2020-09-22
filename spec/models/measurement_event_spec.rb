require 'rails_helper'

RSpec.describe MeasurementEvent, type: :model do
  it "has associations" do
    is_expected.to belong_to(:tank).optional
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
  end
end
