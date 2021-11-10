require 'rails_helper'

RSpec.describe Cohort, type: :model do
  it "Cohort has associations" do
    is_expected.to belong_to(:male).class_name("Animal").optional
    is_expected.to belong_to(:female).class_name("Animal").optional
    is_expected.to belong_to(:organization)
    is_expected.to have_many(:measurements)
    is_expected.to have_many(:animals)
    is_expected.to have_many(:mortality_events)
  end

  describe 'Cohort validations' do
    it { should validate_presence_of(:name) }
    it 'validates name uniquness scoped to organization' do
      cohort_org_1 = build(:cohort, organization: create(:organization))
      expect(cohort_org_1.valid?).to eq(true)
      create(:cohort, name: cohort_org_1.name, organization: cohort_org_1.organization)
      # Name cannot be reused within an originization
      expect(cohort_org_1.valid?).to eq(false)
      # Name is only unique per oginization
      cohort_org_2 = build(:cohort, name: cohort_org_1.name, organization: create(:organization))
      expect(cohort_org_2.valid?).to eq(true)
    end
  end

  include_examples 'organization presence validation' do
    let(:model) { described_class.new name: 'Test Name', organization: organization }
  end

  let!(:cohort) { create(:cohort) }

  it "should have correct amount of mortality_events" do
    animal1 = create(:animal, cohort: cohort)
    animal2 = create(:animal, cohort: cohort)
    create(:animal, cohort: cohort)

    create(:mortality_event, animal: animal1, cohort: cohort)
    create(:mortality_event, animal: animal2, cohort: cohort)

    expect(cohort.mortality_count).to eq 2
  end

  describe 'FactoryBot' do
    it 'creates a cohort' do
      expect(create(:cohort)).to be_valid
    end
  end
end
