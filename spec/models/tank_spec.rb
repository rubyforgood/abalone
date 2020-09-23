require 'rails_helper'

RSpec.describe Tank, type: :model do
  it "Tank has associations" do
    is_expected.to belong_to(:facility).optional
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:post_settlement_inventories)
    is_expected.to have_many(:measurement_events)
    is_expected.to have_many(:measurements)
  end
end
