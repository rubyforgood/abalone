require 'rails_helper'

RSpec.describe Animal, type: :model do
  it "Animal has associations" do
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:cohort).optional
  end
end
