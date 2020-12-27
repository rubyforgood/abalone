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

  include_examples 'organization presence validation'

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
