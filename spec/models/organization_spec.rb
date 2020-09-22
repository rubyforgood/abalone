require 'rails_helper'

RSpec.describe Organization, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it "Organization has associations" do
    is_expected.to have_many(:users)
    is_expected.to have_many(:facilities)
    is_expected.to have_many(:families)
    is_expected.to have_many(:tanks).through(:facilities)
    is_expected.to have_many(:animals)
  end
end
