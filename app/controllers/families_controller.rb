class FamiliesController < ApplicationController
  before_action :set_family, only: %i[show edit update destroy]

  # GET /families
  def index
    # TODO: Scope to org after #334
    @families = Family.all
  end

  # GET /families/1
  def show; end

  # GET /families/new
  def new
    @family = Family.new
  end

  # GET /families/1/edit
  def edit; end

  # POST /families
  def create
    @family = Family.new(family_params)

    if @family.save
      redirect_to @family, notice: 'Family was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /families/1
  def update
    if @family.update(family_params)
      redirect_to @family, notice: 'Family was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /families/1
  def destroy
    @family.destroy

    redirect_to families_url, notice: 'Family was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_family
    @family = Family.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def family_params
    params.require(:family).permit(:name, :male_id, :female_id, :tank_id)
  end
end
