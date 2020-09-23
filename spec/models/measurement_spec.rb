require 'rails_helper'

RSpec.describe Measurement, type: :model do
  it "Measurement has associations" do
    is_expected.to belong_to(:measurement_event)
    is_expected.to belong_to(:processed_file).optional
    is_expected.to belong_to(:tank).optional
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:animal).optional
    is_expected.to belong_to(:family).optional
  end
end
