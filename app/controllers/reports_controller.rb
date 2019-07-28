class ReportsController < ApplicationController
  def index
  end

  def growth_rates
    tags = params[:tags].split(',') || []
    population = Date.parse(params[:population]) rescue nil
    start_date = Date.parse(params[:start_date]) rescue Date.today - 1.week
    end_date = Date.parse(params[:end_date]) rescue Date.today
    @data = Aggregates::Calculations.growth_rates([start_date, end_date], tags, population)
    render json: @data.to_json
  end
end
