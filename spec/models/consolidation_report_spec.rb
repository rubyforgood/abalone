require 'rails_helper'

RSpec.describe ConsolidationReport, type: :model do
  it "ConsolidationReport has associations" do
    is_expected.to belong_to(:family)
    is_expected.to belong_to(:tank_from), class_name: 'Tank'
    is_expected.to belong_to(:tank_to), class_name: 'Tank'
  end
end
