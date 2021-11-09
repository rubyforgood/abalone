require 'rails_helper'

RSpec.describe Cohort, type: :model do
  subject(:cohort) { build_stubbed(:cohort) }

  it "has associations" do
    is_expected.to belong_to(:male).class_name("Animal").optional
    is_expected.to belong_to(:female).class_name("Animal").optional
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:measurements)
    is_expected.to have_many(:animals)
    is_expected.to have_many(:mortality_events)
  end

  describe "Validations >" do
    subject(:cohort) { build(:cohort) }

    it "has a valid factory" do
      expect(cohort).to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:organization_id) }

    it_behaves_like OrganizationScope
  end

  describe "#to_s" do
    it "returns the name assigned to the cohort" do
      expect(cohort.to_s).to eq(cohort.name)
    end

    context "without a name" do
      before { cohort.name = nil }

      it "returns a string with the Cohort ID" do
        expect(cohort.to_s).to eq("Cohort #{cohort.id}")
      end
    end
  end

  describe "#mortality_count" do
    it "returns count of mortality_events" do
      create_list(:mortality_event, 4, cohort: cohort)
      create_list(:mortality_event, 3, cohort: cohort)

      expect(cohort.mortality_count).to eq(7)
    end
  end
end
