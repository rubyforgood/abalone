require 'rails_helper'

RSpec.describe ShlNumber, type: :model do
  it "SHL Number has associations" do
    is_expected.to have_many(:animals_shl_numbers)
    is_expected.to have_many(:animals).through(:animals_shl_numbers)
  end
end
