require 'rails_helper'

RSpec.describe MortalityEvent, :aggregate_failures, type: :model do
  it "Mortality Event has associations" do
    is_expected.to belong_to(:animal).optional
    is_expected.to belong_to(:cohort)
    is_expected.to belong_to(:organization)
    is_expected.to belong_to(:exit_type).optional
    is_expected.to belong_to(:processed_file).optional
  end

  include_examples 'organization presence validation' do
    let(:model) { described_class.new animal: build(:animal), cohort: build(:cohort), organization: organization }
  end

  describe "#create_from_csv_data" do
    let(:cohort) { create(:cohort, name: "Aquarium of the Pacific location enclosure cohort", organization: organization) }
    let(:animal) { create(:animal, tag: "F-AOP", organization: organization) }
    let(:organization) { create(:organization) }
    let(:exit_type) { create(:exit_type, organization: organization) }
    let(:mortality_date) { "2021/10/11" }
    let(:processed_file) { create(:processed_file) }

    subject { described_class.create_from_csv_data(attrs) }

    context "for a Mortality Event for an Animal" do
      let(:attrs) do
        {
          processed_file_id: processed_file.id,
          date: mortality_date,
          tag: animal.tag,
          cohort_name: cohort.name,
          organization_id: organization.id,
          measurement_type: "animal mortality event",
          reason: exit_type.name
        }
      end

      it 'has an associated processed file' do
        expect(subject.processed_file).to eq(processed_file)
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
          processed_file_id: processed_file.id,
          date: mortality_date,
          cohort_name: cohort.name,
          organization_id: organization.id,
          measurement_type: "cohort mortality event",
          value: "3",
          reason: exit_type.name
        }
      end

      it 'has an associated processed file' do
        expect(subject.processed_file).to eq(processed_file)
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

      it 'is not a mortality event for an animal' do
        expect(subject.animal).to eq(nil)
      end
    end

    context "when no exit_type is present" do
      let(:attrs) do
        {
          processed_file_id: processed_file.id,
          date: mortality_date,
          cohort_name: cohort.name,
          organization_id: organization.id,
          measurement_type: "cohort mortality event",
          value: "3"
        }
      end

      it 'fails without an exit_type' do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end

  describe "#display_data" do
    subject { mortality_event.display_data }

    context "for an Animal" do
      let(:enclosure) { build(:enclosure, name: "Tank 2") }
      let(:cohort) { build(:cohort, name: "Aquarium of the Pacific location enclosure cohort", enclosure: enclosure) }
      let(:animal) { build(:animal, tag: "R2D2-PO", cohort: cohort) }
      let(:exit_type) { build(:exit_type, name: "sacrifical clam") }
      let(:mortality_event) { build(:mortality_event, mortality_date: "2021-10-11 00:00:00.000000000 +0000", animal: animal, cohort: cohort, exit_type: exit_type) }

      it 'returns the correct data for displaying an animal mortality event' do
        expect(subject).to eq(
          [
            "2021-10-11 00:00:00.000000000 +0000", "Animal", "mortality event", nil, nil, "Tank 2", "Aquarium of the Pacific location enclosure cohort", "R2D2-PO", "sacrifical clam"
          ]
        )
      end
    end

    context "for a Cohort" do
      let(:enclosure) { build(:enclosure, name: "Tank 2") }
      let(:cohort) { build(:cohort, name: "Aquarium of the Pacific location enclosure cohort", enclosure: enclosure) }
      let(:exit_type) { build(:exit_type, name: "sacrifical clam") }
      let(:mortality_event) { build(:mortality_event, :for_cohort, mortality_date: "2021-10-11 00:00:00.000000000 +0000", mortality_count: 12, cohort: cohort, exit_type: exit_type) }

      it 'returns the correct data for displaying a cohort mortality event' do
        expect(subject).to eq(
          [
            "2021-10-11 00:00:00.000000000 +0000", "Cohort", "mortality event", 12, nil, "Tank 2", "Aquarium of the Pacific location enclosure cohort", nil, "sacrifical clam"
          ]
        )
      end
    end
  end
end
