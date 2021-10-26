require "rails_helper"

RSpec.describe MeasurementJob do
  let(:filename) { "basic_measurement.csv" }

  it_behaves_like "import job" do
    let!(:organization) { create(:organization) }
    let!(:measurement_type) { create(:measurement_type, name: 'count', unit: 'number', organization_id: organization.id) }
    let!(:measurement_type2) { create(:measurement_type, name: 'length', unit: 'number', organization_id: organization.id) }
  end
end
