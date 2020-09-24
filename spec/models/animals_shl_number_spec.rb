require 'rails_helper'

RSpec.describe AnimalsShlNumber, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it "Animals SHL Numbers has associations" do
    is_expected.to belong_to(:animal)
    is_expected.to belong_to(:shl_number)
  end
end
