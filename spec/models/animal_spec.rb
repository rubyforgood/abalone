require 'rails_helper'

RSpec.describe Animal, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it "Animal has associations" do
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
  end
end
