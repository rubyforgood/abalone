require 'rails_helper'

RSpec.describe Enclosure, type: :model do
  it "Enclosure has associations" do
    is_expected.to belong_to(:facility).optional
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:measurements)
  end
end
