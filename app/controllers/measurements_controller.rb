class MeasurementsController < ApplicationController
  def index
    @measurements = Measurement.all
  end
  def new; end
end
