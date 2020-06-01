class OperationsController < ApplicationController
  def index
    @operations = Operation.all
                           .joins(:family, :tank)
                           .includes(:family, :tank)
  end
end
