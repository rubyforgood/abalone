require "rails_helper"

RSpec.describe WildCollectionJob do
  let(:filename) { "example_of_wild_collection_data.csv" }

  skip 'Ellen noticed heroku worker cannot process csv saved to disk so will need to change how we move forward' do
    it_behaves_like "import job"
  end
end
