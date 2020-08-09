require "rails_helper"

RSpec.describe TaggedAnimalAssessmentJob do
  let(:filename) { "Tagged_assessment_12172018(original).csv" }

  it_behaves_like "import job"
end
