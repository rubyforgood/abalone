class TanksController < ApplicationController
  before_action :set_tank, only: [:show]

  def show; end

  private

  def set_tank
    @tank = Tank.find(params[:id])
  end
end
