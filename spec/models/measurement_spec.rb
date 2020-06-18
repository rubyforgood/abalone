require 'rails_helper'

RSpec.describe Measurement, type: :model do
  it "Measurement has associations" do
    is_expected.to belong_to(:measurement_event)
    is_expected.to belong_to(:processed_file).optional
  end
end
