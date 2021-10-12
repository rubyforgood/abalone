class MeasurementsController < ApplicationController
  def index
    @measurements = Measurement.all
  end

  def show
    @measurement = Measurement.find(params[:id])
  end

  def edit; end

  def update; end

  def new; end
end
