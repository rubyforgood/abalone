require 'rails_helper'

RSpec.describe Animal, type: :model do
  it "Animal has associations" do
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:cohort).optional
    is_expected.to have_many(:animals_shl_numbers).dependent(:destroy)
    is_expected.to have_many(:shl_numbers).through(:animals_shl_numbers)
  end

  include_examples 'organization presence validation'
end
