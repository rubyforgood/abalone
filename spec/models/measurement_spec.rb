require 'rails_helper'

RSpec.describe Measurement, type: :model do
  it "Measurement has associations" do
    is_expected.to belong_to(:measurement_event)
    is_expected.to belong_to(:processed_file).optional
    is_expected.to belong_to(:subject)
    is_expected.to belong_to(:measurement_type)
    is_expected.to belong_to(:organization)
  end

  include_examples 'organization presence validation' do
    let(:model) do
      described_class.new(measurement_event: create(:measurement_event),
                          measurement_type: create(:measurement_type),
                          subject: create(:animal),
                          value: '200',
                          organization: organization)
    end
  end

  context "#data_for_file" do
    let(:processed_file) { create :processed_file }
    let!(:measurement) { create :measurement, processed_file: processed_file }
    let!(:mortality_event) { create :mortality_event, processed_file: processed_file }

    subject { described_class.data_for_file(processed_file.id) }

    it { is_expected.to match_array([measurement, mortality_event]) }
  end

  context "#display_data" do
    let(:animal) { build :animal, tag: "BB8-L8" }
    let(:measurement_type) { build :measurement_type, name: "gonad score" }
    let(:measurement_event) { build :measurement_event, name: "Gonad Survey" }
    let(:measurement) do
      build :measurement, subject: animal, measurement_type: measurement_type, measurement_event: measurement_event, value: "12", date: "2021-10-11 00:00:00.000000000 +0000"
    end

    subject { measurement.display_data }

    it 'returns the correct data for displaying a measurement' do
      expect(subject).to eq(
        [
          "2021-10-11 00:00:00.000000000 +0000", "Animal", "gonad score", "12", "Gonad Survey", nil, nil, "BB8-L8", nil
        ]
      )
    end
  end
end
