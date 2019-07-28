class ReportsController < ApplicationController
  def index
  end

  def lengths_for_measurement(measurement)
    @total_animal_lengths = TaggedAnimalAssessment.lengths_for_measurement(measurement) +
        UntaggedAnimalAssessment.lengths_for_measurement(measurement)
  end
end
