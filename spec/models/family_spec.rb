require 'rails_helper'

RSpec.describe Family, type: :model do
  it "Family has associations" do
    is_expected.to belong_to(:male).class_name("Animal")
    is_expected.to belong_to(:female).class_name("Animal")
  end
end
