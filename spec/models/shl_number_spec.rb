require 'rails_helper'

RSpec.describe ShlNumber, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it "SHL Number has associations" do
    is_expected.to have_many(:animals_shl_numbers)
    is_expected.to have_many(:animals).through(:animals_shl_numbers)
  end
end
