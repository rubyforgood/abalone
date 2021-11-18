require 'rails_helper'

RSpec.describe Animal, type: :model do
  subject(:animal) { build_stubbed(:animal) }

  it "has associations" do
    is_expected.to have_many(:measurements)
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:cohort).optional
    is_expected.to have_many(:animals_shl_numbers).dependent(:destroy)
    is_expected.to have_many(:shl_numbers).through(:animals_shl_numbers)
    is_expected.to have_one(:mortality_event)
  end

  describe "Validations >" do
    subject(:animal) { build(:animal) }

    it "has a valid factory" do
      expect(animal).to be_valid
    end

    it_behaves_like OrganizationScope

    it { is_expected.to validate_presence_of(:sex) }
    it { is_expected.to validate_uniqueness_of(:tag).scoped_to(:cohort_id) }
\

    context "without an entry_point for a collected animal" do
      before { animal.collected = true }

      it { is_expected.to validate_presence_of(:entry_point) }
    end

    context "without an entry_point for a spawned animal" do
      before { animal.entry_point = "" }

      it { is_expected.not_to validate_presence_of(:entry_point) }
    end
  end

  describe "Callbacks >" do
    it "initializes with default sex 'unknown'" do
      expect(Animal.new.sex).to eq("unknown")
    end
  end

  describe "#shl_number_codes" do
    before do
      animal.shl_numbers.create(code: "first_code")
      animal.shl_numbers.create(code: "second_code")
    end

    it "returns shl_number_codes as a comma-delimited string" do
      expect(animal.shl_number_codes).to eq("first_code,second_code")
    end

    context "with a delimeter provided" do
      it "returns shl_number_codes delimited by the provided string" do
        expect(animal.shl_number_codes("|")).to eq("first_code|second_code")
      end
    end
  end

  describe "#alive" do
    it { is_expected.to be_alive }

    context "with a mortality event" do
      before { create(:mortality_event, animal: animal) }

      it { is_expected.not_to be_alive }
    end
  end

  describe "#dead" do
    it { is_expected.not_to be_dead }

    context "with a mortality event" do
      before { create(:mortality_event, animal: animal) }

      it { is_expected.to be_dead }
    end
  end
end
