class ShowsController < ApplicationController
  before_action :set_show, only: %i[ show edit update destroy ]

  # GET /shows or /shows.json
  def index
    @shows = Show.all
  end

  # GET /shows/1 or /shows/1.json
  def show
  end

  # GET /shows/new
  def new
    @show = Show.new
  end

  # GET /shows/1/edit
  def edit
  end

  # POST /shows or /shows.json
  def create
    @show = Show.new(show_params.except(:genres))
    create_genres_shows(@show, params[:show][:genres])

    respond_to do |format|
      if @show.save
        format.html { redirect_to @show, notice: "Show was successfully created." }
        format.json { render :show, status: :created, location: @show }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shows/1 or /shows/1.json
  def update
    create_genres_shows(@show, params[:show][:genres])
    respond_to do |format|
      if @show.update(show_params.except(:genres))
        format.html { redirect_to @show, notice: "Show was successfully updated." }
        format.json { render :show, status: :ok, location: @show }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1 or /shows/1.json
  def destroy
    @show.destroy!

    respond_to do |format|
      format.html { redirect_to shows_path, status: :see_other, notice: "Show was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params.expect(:id))
    end

    def create_genres_shows(show, genres)
      if genres.present?
        show.genres_shows.destroy_all
        genres.split(",").each do |genre|
          genre.strip!
          show.genres << Genre.find_by(name: genre)
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def show_params
      params.expect(show: [ :title, :genres ])
    end
end
