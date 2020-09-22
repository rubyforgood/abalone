class UsersController < ApplicationController
  before_action :admin?, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  def index
    @users = current_user.organization.users
  end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def admin?
    redirect_to root_path, alert: "Not authorized" if !current_user.admin?
  end
end
