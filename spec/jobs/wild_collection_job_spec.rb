require "rails_helper"

RSpec.describe WildCollectionJob do
  let(:filename) { "example_of_wild_collection_data.csv" }

  before do
    Rails.application.load_seed if Facility.valid_codes.empty?
  end

  it_behaves_like "import job"
end
