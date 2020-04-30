require "rails_helper"

RSpec.describe MeasurementJob do
  let(:filename) { "basic_measurement.csv" }

  it_behaves_like "import job"
end
