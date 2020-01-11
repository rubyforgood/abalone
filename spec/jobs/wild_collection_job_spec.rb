require "rails_helper"

RSpec.describe WildCollectionJob do
  let(:filename) { "example_of_wild_collection_data.csv" }

  it_behaves_like "import job"
end
