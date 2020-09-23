class UsersController < ApplicationController
  before_action :admin?, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:show]

  def index
    @users = current_organization.users
  end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin?
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end
