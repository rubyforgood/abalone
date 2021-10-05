class ExitTypesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_exit_type, only: %i[show edit update destroy]
  before_action :of_organization, only: %i[show edit update destroy]

  def index
    @exit_types = ExitType.all.for_organization(current_organization)
  end

  def show; end

  def new
    @exit_type = ExitType.new
  end

  def edit; end

  def create
    @exit_type = ExitType.new(exit_type_params)

    if @exit_type.save
      redirect_to @exit_type, notice: "Exit type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @exit_type.update(exit_type_params)
      redirect_to @exit_type, notice: "Exit type was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @exit_type.mortality_events.empty?
      @exit_type.destroy
      redirect_to exit_types_url, notice: "Exit type was successfully destroyed."
    else
      redirect_to exit_types_path, alert: 'Some mortality events are using this exit type'
    end
  end

  private

  def set_exit_type
    @exit_type = ExitType.find(params[:id])
  end

  def exit_type_params
    params.require(:exit_type).permit(:name, :disabled).merge(organization_id: current_organization.id)
  end

  def of_organization
    return unless @exit_type.organization_id != current_organization.id

    redirect_to exit_types_url, alert: "You can only interact with exit types of your organization."
  end
end
