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

  describe "entry point" do
    before { animal.entry_point = "" }

    context "collected animal" do    
      it "is not valid with a blank entry point" do
        expect(animal).to_not be_valid
      end
    end

    context "spawned animal" do
      it "allows blank entry point" do
        animal.collected = false
        expect(animal).to be_valid
      end
    end
  end
end
