require 'rails_helper'

RSpec.describe Operation, type: :model do
  it "Operation has associations" do
    is_expected.to belong_to(:tank)
  end
end
