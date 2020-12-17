class CohortImportsController < ApplicationController
  def new; end

  def create
    Cohort.create! organization: current_organization
    redirect_to cohorts_path
  end
end
