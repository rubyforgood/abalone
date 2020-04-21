require 'rails_helper'

RSpec.describe MeasurementEvent, type: :model do
  it "has associations" do
    is_expected.to belong_to(:tank)
    is_expected.to have_many(:measurements)
  end
end
