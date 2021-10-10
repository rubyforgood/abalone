class UsersController < ApplicationController
  before_action :authorize_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :of_organization, only: %i[show edit update destroy]

  def index
    @users = current_organization.users
  end

  def show
    redirect_to users_path unless @user
  end

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

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :role
    ).merge(organization_id: current_organization.id)
  end

  def set_user
    @user = current_organization.users.find_by(id: params[:id])
  end

  def of_organization
    authorize! :same_organization, @user
  end
end
