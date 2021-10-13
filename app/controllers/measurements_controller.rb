class MeasurementsController < ApplicationController
  def index
    @measurements = Measurement.all
  end

  def show
    @measurement = Measurement.find(params[:id])
  end

  def edit
    @measurement = Measurement.find(params[:id])
  end

  def update; end

  def new; end
end
