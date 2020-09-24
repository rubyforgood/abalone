class UsersController < ApplicationController
  before_action :admin?, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_password, :update_password]
  before_action :current_user?, only: [:edit_password, :update_password]

  def index
    @users = current_organization.users
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

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    notice_message = 'User cannot delete itself.'

    unless @user == current_user
      @user.destroy
      notice_message = 'User was successfully destroyed.'
    end

    redirect_to users_url, notice: notice_message
  end

  def edit_password; end

  def update_password
    if @user.update(user_params)
      sign_in(@user, bypass: true)
      redirect_to edit_password_users_url, notice: 'Password was successfully updated.'
    else
      render :edit_password
    end
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

  def current_user?
    redirect_to root_path, alert: "Not authorized" unless current_user == @user
  end
end
