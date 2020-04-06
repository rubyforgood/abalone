require 'rails_helper'

RSpec.describe PostSettlementInventory, type: :model do
  it "PostSettlementInventory has associations" do
    is_expected.to belong_to(:tank)
  end
end
