require 'rails_helper'

RSpec.describe MortalityEvent, type: :model do
  it "Mortality Event has associations" do
    is_expected.to belong_to(:animal)
    is_expected.to belong_to(:cohort)
  end
end
