class UsersController < ApplicationController
  before_action :admin?, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = current_organization.users.reject { |user| user == current_user }
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy
    @user.destroy

    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :role
    ).merge(organization_id: current_organization.id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin?
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end
