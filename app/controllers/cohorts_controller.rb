class CohortsController < ApplicationController
  load_and_authorize_resource

  def index
    @cohorts = Cohort.for_organization(current_organization)

    respond_to do |format|
      format.html
      format.csv { send_data @cohorts.to_csv, filename: "#{Date.today.iso8601}-cohorts.csv" }
    end
  end

  def show; end

  def new
    @cohort = Cohort.new
  end

  def edit; end

  def create
    @cohort = Cohort.new(cohort_params)

    if @cohort.save
      redirect_to @cohort, notice: 'Cohort was successfully created.'
    else
      render :new
    end
  end

  def update
    if @cohort.update(cohort_params)
      redirect_to @cohort, notice: 'Cohort was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @cohort.destroy

    redirect_to cohorts_url, notice: 'Cohort was successfully destroyed.'
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def cohort_params
    params.require(:cohort).permit(
      :name,
      :male_id,
      :female_id,
      :enclosure_id
    ).merge(organization_id: current_organization.id)
  end
end
