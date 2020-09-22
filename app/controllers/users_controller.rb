class UsersController < ApplicationControler
  before_action :admin?, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  def index; end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def admin?
    current_user.admin?
  end
end
