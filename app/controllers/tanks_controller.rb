class TanksController < ApplicationController
  before_action :set_tank, only: [:show]

  def index
    @tanks = Tank.all
  end

  def show; end

  private

  def set_tank
    @tank = Tank.find(params[:id])
  end
end
