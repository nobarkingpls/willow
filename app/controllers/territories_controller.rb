class TerritoriesController < ApplicationController
  before_action :set_territory, only: %i[ show edit update destroy ]

  # GET /territories or /territories.json
  def index
    @territories = Territory.all
  end

  # GET /territories/1 or /territories/1.json
  def show
  end

  # GET /territories/new
  def new
    @territory = Territory.new
  end

  # GET /territories/1/edit
  def edit
  end

  # POST /territories or /territories.json
  def create
    @territory = Territory.new(territory_params)

    respond_to do |format|
      if @territory.save
        format.html { redirect_to @territory, notice: "Territory was successfully created." }
        format.json { render :show, status: :created, location: @territory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @territory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /territories/1 or /territories/1.json
  def update
    respond_to do |format|
      if @territory.update(territory_params)
        format.html { redirect_to @territory, notice: "Territory was successfully updated." }
        format.json { render :show, status: :ok, location: @territory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @territory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /territories/1 or /territories/1.json
  def destroy
    @territory.destroy!

    respond_to do |format|
      format.html { redirect_to territories_path, status: :see_other, notice: "Territory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_territory
      @territory = Territory.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def territory_params
      params.expect(territory: [ :code ])
    end
end
