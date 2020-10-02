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
end
