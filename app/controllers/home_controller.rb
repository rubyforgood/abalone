class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    return unless current_user

    # Retrive current organization stats
    @facility_count = current_user.organization.facilities.count
    @cohort_count = current_user.organization.cohorts.count
    @animal_count = current_user.organization.animals.count
  end

  def show; end
end
