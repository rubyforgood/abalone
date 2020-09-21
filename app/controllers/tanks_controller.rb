class TanksController < ApplicationController
  before_action :set_tank, only: [:show]

  def show; end

  def new
    @tank = Tank.new
  end

  def create
    @tank = Tank.new(tank_params)
    if @tank.save
      redirect_to tank_path(@tank), notice: 'Tank was successfully created.'
    else
      render :new
    end
  end

  private

  def set_tank
    @tank = Tank.find(params[:id])
  end

  def tank_params
    params.require(:tank).permit(:facility_id, :name)
  end
end
