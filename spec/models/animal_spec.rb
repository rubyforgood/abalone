require 'rails_helper'

RSpec.describe Animal, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it "Animal has associations" do
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:animals_shl_numbers).dependent(:destroy)
    is_expected.to have_many(:shl_numbers).through(:animals_shl_numbers)
  end
end
