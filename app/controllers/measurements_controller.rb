class MeasurementsController < ApplicationController
  def index
    @measurements = Measurement.all
  end

  def show; end

  def new; end
end
