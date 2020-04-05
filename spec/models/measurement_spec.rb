require 'rails_helper'

RSpec.describe Measurement, type: :model do
  it "Measurement has associations" do
    is_expected.to belong_to(:tank)
  end
end
