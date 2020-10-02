require 'rails_helper'

RSpec.describe Organization, type: :model do
  it "Organization has associations" do
    is_expected.to have_many(:users)
    is_expected.to have_many(:facilities)
    is_expected.to have_many(:cohorts)
    is_expected.to have_many(:enclosures)
    is_expected.to have_many(:measurements)
    is_expected.to have_many(:measurement_events)
    is_expected.to have_many(:operations)
    is_expected.to have_many(:animals)
  end
end
