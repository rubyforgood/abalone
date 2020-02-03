require "rails_helper"

RSpec.describe WildCollectionJob do
  let(:filename) { "example_of_wild_collection_data.csv" }

  before(:all) do
    Rails.application.load_seed
  end

  it_behaves_like "import job"
end
