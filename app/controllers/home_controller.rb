class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    # Retrive current user stats or assign defaults
    if current_user
      @facility_count = current_user.organization.facilities.count
      @cohort_count = current_user.organization.cohorts.count
      @animal_count = current_user.organization.animals.count
    end
  end

  def show; end
end
