class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.all
    begin
      @searched_movie = Movie.find(params[:movie_id])
    rescue
      nil
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params.except(:actors, :genres, :countries))
    create_actors_movies(@movie, params[:movie][:actors])
    create_genres_movies(@movie, params[:movie][:genres])
    create_countries_movies(@movie, params[:movie][:countries])
    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    create_actors_movies(@movie, params[:movie][:actors])
    create_genres_movies(@movie, params[:movie][:genres])
    create_countries_movies(@movie, params[:movie][:countries])
    respond_to do |format|
      if @movie.update(movie_params.except(:actors, :genres, :countries))
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!
    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def create_actors_movies(movie, actors)
      if actors.present?
        movie.actors_movies.destroy_all
        actors.split(",").each do |actor|
          actor.strip!
          movie.actors << Actor.find_or_create_by(name: actor)
        end
      end
    end

    def create_genres_movies(movie, genres)
      if genres.present?
        movie.genres_movies.destroy_all
        genres.split(",").each do |genre|
          genre.strip!
          movie.genres << Genre.find_by(name: genre)
        end
      end
    end

    def create_countries_movies(movie, countries)
      if countries.present?
        movie.countries_movies.destroy_all
        countries.split(",").each do |country|
          country.strip!
          movie.countries << Country.find_by(code: country)
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :actors, :genres, :countries, :start, :finish)
    end
end
