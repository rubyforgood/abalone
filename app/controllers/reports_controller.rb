# frozen_string_literal: true

class ReportsController < ApplicationController
  def index; end

  def lengths_for_measurement
    @processed_file_id = params[:processed_file_id]
    @total_animal_lengths = TaggedAnimalAssessment.lengths_for_measurement(@processed_file_id) +
                            UntaggedAnimalAssessment.lengths_for_measurement(@processed_file_id)

    respond_to do |format|
      format.json do
        render json: {
          processed_file_id: @processed_file_id,
          total_animal_lengths: @total_animal_lengths
        }
      end
    end
  end
end
