class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    # Retrive current user stats or assign defaults
    @facility_count = current_user&.organization&.facilities&.count || 3
    @cohort_count = current_user&.organization&.cohorts&.count || 7
    @animal_count = current_user&.organization&.animals&.count || 41
  end

  def show; end
end
