require 'rails_helper'

RSpec.describe MortalityEvent, type: :model do
  it "Mortality Event has associations" do
    is_expected.to belong_to(:animal).optional
    is_expected.to belong_to(:cohort)
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:exit_type).optional
  end

  include_examples 'organization presence validation' do
    let(:model) { described_class.new animal: build(:animal), cohort: build(:cohort), organization: organization }
  end

  describe "#create_from_csv_data", :aggregate_failures do
    let(:cohort) { create(:cohort, name: "Aquarium of the Pacific location enclosure cohort", organization: organization) }
    let(:animal) { create(:animal, tag: "F-AOP", organization: organization) }
    let(:organization) { create(:organization) }
    let(:exit_type) { create(:exit_type, organization: organization) }
    let(:mortality_date) { "2021/10/11" }

    subject { described_class.create_from_csv_data(attrs) }

    context "for a Mortality Event for an Animal" do
      let(:attrs) do
        {
          mortality_date: mortality_date,
          tag: animal.tag,
          cohort_name: cohort.name,
          organization_id: organization.id,
          measurement_type: "animal mortality event",
          reason: exit_type.name
        }
      end

      it 'has the correct mortality_date' do
        expect(subject.mortality_date).to eq(mortality_date)
      end

      it 'has the correct animal' do
        expect(subject.animal).to eq(animal)
      end

      it 'has the correct cohort' do
        expect(subject.cohort).to eq(cohort)
      end

      it 'has the correct organization' do
        expect(subject.organization).to eq(organization)
      end

      it 'has the correct exit type' do
        expect(subject.exit_type).to eq(exit_type)
      end
    end

    context "creates a Mortality Event for a Cohort" do
      let(:attrs) do
        {
          mortality_date: mortality_date,
          cohort_name: cohort.name,
          organization_id: organization.id,
          measurement_type: "cohort mortality event",
          value: "3",
          reason: exit_type.name
        }
      end

      it 'has the correct mortality_date' do
        expect(subject.mortality_date).to eq(mortality_date)
      end

      it 'has the correct cohort' do
        expect(subject.cohort).to eq(cohort)
      end

      it 'has the correct organization' do
        expect(subject.organization).to eq(organization)
      end

      it 'has the correct mortality count' do
        expect(subject.mortality_count).to eq(3)
      end

      it 'has the correct exit type' do
        expect(subject.exit_type).to eq(exit_type)
      end
    end
  end
end
