class OperationsController < ApplicationController
  def index
    @operations = Operation.all
  end
end
