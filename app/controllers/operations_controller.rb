class OperationsController < ApplicationController
  def index
    @operations = Operation.for_organization(current_organization)
                           .joins(:family, :tank)
                           .includes(:family, :tank)
  end
end
