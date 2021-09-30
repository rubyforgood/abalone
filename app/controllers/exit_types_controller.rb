class ExitTypesController < ApplicationController
  before_action :set_exit_type, only: %i[ show edit update destroy ]

  # GET /exit_types or /exit_types.json
  def index
    @exit_types = ExitType.all
  end

  # GET /exit_types/1 or /exit_types/1.json
  def show
  end

  # GET /exit_types/new
  def new
    @exit_type = ExitType.new
  end

  # GET /exit_types/1/edit
  def edit
  end

  # POST /exit_types or /exit_types.json
  def create
    @exit_type = ExitType.new(exit_type_params)

    respond_to do |format|
      if @exit_type.save
        format.html { redirect_to @exit_type, notice: "Exit type was successfully created." }
        format.json { render :show, status: :created, location: @exit_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exit_types/1 or /exit_types/1.json
  def update
    respond_to do |format|
      if @exit_type.update(exit_type_params)
        format.html { redirect_to @exit_type, notice: "Exit type was successfully updated." }
        format.json { render :show, status: :ok, location: @exit_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exit_types/1 or /exit_types/1.json
  def destroy
    @exit_type.destroy
    respond_to do |format|
      format.html { redirect_to exit_types_url, notice: "Exit type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exit_type
      @exit_type = ExitType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def exit_type_params
      params.require(:exit_type).permit(:name, :disabled, :organization_id)
    end
end
