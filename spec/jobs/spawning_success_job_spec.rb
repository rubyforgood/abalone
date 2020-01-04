require "rails_helper"

RSpec.describe SpawningSuccessJob do
  let(:filename) { "example_of_spawning_success_data.csv" }

  it_behaves_like "import job"
end
