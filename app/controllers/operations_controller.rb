class OperationsController < ApplicationController
  def index
    @operations = Operation.for_organization(current_organization)
                           .joins(:cohort, :enclosure)
                           .includes(:cohort, :enclosure)
  end
end
