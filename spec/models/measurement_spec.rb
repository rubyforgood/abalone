require 'rails_helper'

RSpec.describe Measurement, type: :model do
  subject(:measurement) { build_stubbed(:measurement) }

  it "has associations" do
    is_expected.to belong_to(:measurement_event)
    is_expected.to belong_to(:processed_file).optional
    is_expected.to belong_to(:subject)
    is_expected.to belong_to(:measurement_type)
    is_expected.to belong_to(:organization)
  end

  describe "Validations >" do
    subject(:measurement) { build(:measurement) }

    it "has a valid factory" do
      expect(measurement).to be_valid
    end

    it_behaves_like OrganizationScope

    it { is_expected.to validate_presence_of(:subject_type) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_inclusion_of(:subject_type).in_array(%w[Cohort Enclosure Animal]) }
  end

  describe ".data_for_file" do
    let(:processed_file) { create :processed_file }
    let!(:measurement) { create :measurement, processed_file: processed_file }
    let!(:mortality_event) { create :mortality_event, processed_file: processed_file }

    subject { described_class.data_for_file(processed_file.id) }

    it { is_expected.to match_array([measurement, mortality_event]) }
  end

  describe "#display_data" do
    subject(:measurement) do
      build(
        :measurement,
        subject: build(:animal, tag: "BB8-L8"),
        measurement_type: build(:measurement_type, name: "gonad score"),
        measurement_event: build(:measurement_event, name: "Gonad Survey"),
        value: "12",
        date: "2021-10-11 00:00:00.000000000 +000"
      )
    end

    it 'returns the correct data for displaying a measurement' do
      expect(measurement.display_data).to eq(
        [
          "2021-10-11 00:00:00.000000000 +0000",
          "Animal",
          "gonad score",
          "12",
          "Gonad Survey",
          nil,
          nil,
          "BB8-L8",
          nil
        ]
      )
    end
  end

  describe "#cohort_name" do
    it "returns nil without an associated cohort subject" do
      expect(measurement.cohort_name).to be_nil
    end

    context "with an associated cohort as the subject" do
      let(:cohort) { build_stubbed(:cohort) }

      before { measurement.subject = cohort }

      it "returns the associated cohort name" do
        expect(measurement.cohort_name).to eq(cohort.name)
      end
    end
  end

  describe "#enclosure_name" do
    it "returns nil without an associated enclosure subject" do
      expect(measurement.enclosure_name).to be_nil
    end

    context "with an associated cohort as the subject" do
      let(:enclosure) { build_stubbed(:enclosure) }

      before { measurement.subject = enclosure }

      it "returns the associated enclosure name" do
        expect(measurement.enclosure_name).to eq(enclosure.name)
      end
    end
  end

  describe "#animal_tag" do
    it "returns nil without an associated animal subject" do
      measurement.subject = nil
      expect(measurement.animal_tag).to be_nil
    end

    context "with an associated cohort as the subject" do
      let(:animal) { build_stubbed(:animal) }

      before { measurement.subject = animal }

      it "returns the associated animal_tag name" do
        expect(measurement.animal_tag).to eq(animal.tag)
      end
    end
  end
end
