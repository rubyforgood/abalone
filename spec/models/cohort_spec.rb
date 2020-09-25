require 'rails_helper'

RSpec.describe Cohort, type: :model do
  it "Cohort has associations" do
    is_expected.to belong_to(:male).class_name("Animal").optional
    is_expected.to belong_to(:female).class_name("Animal").optional
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:measurements)
    is_expected.to have_many(:animals)
  end
end
