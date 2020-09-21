class TanksController < ApplicationController
  before_action :set_tank, only: [:show, :destroy]

  def index
    @tanks = Tank.all
  end

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

  # DELETE /tanks/1
  # DELETE /tanks/1.json
  def destroy
    @tank.destroy
    respond_to do |format|
      format.html { redirect_to tanks_url, notice: 'Tank was successfully destroyed.' }
      format.json { head :no_content }
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
