class UsersController < ApplicationController
  before_action :admin?, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:show]

  def index; end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def admin?
    redirect_to root_path unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end
end
