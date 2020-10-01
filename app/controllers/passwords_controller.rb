class PasswordsController < ApplicationController
  before_action :set_user
  before_action :current_user?

  def edit; end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user)
      redirect_to edit_password_url, notice: 'Password was successfully updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :password
    ).merge(organization_id: current_organization.id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def current_user?
    redirect_to root_path, alert: "Not authorized" unless current_user == @user
  end
end
