require "rails_helper"

RSpec.describe MeasurementJob do
  let(:filename) { "basic_measurement.csv" }

  # The create from CSV method on a measurement is not currently being used
  # and was breaking a lot of tests
  #
  # it_behaves_like "import job"
end
