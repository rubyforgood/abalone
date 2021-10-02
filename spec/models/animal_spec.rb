require 'rails_helper'

RSpec.describe Animal, type: :model do
  it "Animal has associations" do
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:cohort).optional
    is_expected.to have_many(:animals_shl_numbers).dependent(:destroy)
    is_expected.to have_many(:shl_numbers).through(:animals_shl_numbers)
    is_expected.to have_one(:mortality_event)
  end

  include_examples 'organization presence validation'

  let!(:animal) { create(:animal) }

  it "should be dead" do
    create(:mortality_event, animal: animal, cohort: create(:cohort))

    expect(animal.dead?).to eq true
  end

  it "should be alive" do
    expect(animal.alive?).to eq true
  end

  context "entry point" do
    before { animal.entry_point = "" }

    it "can be blank for spawned animals" do
      expect(animal).to be_valid
    end

    it "cannot be blank for collected animals" do
      animal.collected = true
      expect(animal).not_to be_valid
    end
  end
end
