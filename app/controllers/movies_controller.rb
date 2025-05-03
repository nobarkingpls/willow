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
    @movie = Movie.find(params[:id])
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params.except(:actors, :genres, :countries, :territories, :images))
    create_actors_movies(@movie, params[:movie][:actors])
    create_genres_movies(@movie, params[:movie][:genres])
    create_countries_movies(@movie, params[:movie][:countries])
    create_movies_territories(@movie, params[:movie][:territories])

    respond_to do |format|
      if @movie.save

        if params[:movie][:images].present?
          params[:movie][:images].reject(&:blank?).each do |uploaded_file|
            filename = uploaded_file.original_filename

            if filename.include?("test") || filename.include?("second")
              @movie.attach_image_with_custom_key(uploaded_file)
            end
          end
        end

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
    # methods for handling these specific jobs
    create_actors_movies(@movie, params[:movie][:actors])
    create_genres_movies(@movie, params[:movie][:genres])
    create_countries_movies(@movie, params[:movie][:countries])
    create_movies_territories(@movie, params[:movie][:territories])

    # handle image updates
    if params[:movie][:images].present?
      params[:movie][:images].reject(&:blank?).each do |uploaded_file|
        # Check if uploaded_file is a file object or a string
        if uploaded_file.respond_to?(:original_filename)
          filename = uploaded_file.original_filename
        else
          filename = uploaded_file # Treat it as a path or string
        end

        if filename.include?("test") || filename.include?("second")
          # Remove existing attachment with matching pattern
          @movie.images.each do |image|
            existing_filename = image.filename.to_s
            if existing_filename.include?("test") && filename.include?("test")
              image.purge
            elsif existing_filename.include?("second") && filename.include?("second")
              image.purge
            end
          end

          # Attach the new file
          @movie.attach_image_with_custom_key(uploaded_file)
        end
      end
    end

    respond_to do |format|
      if @movie.update(movie_params.except(:actors, :genres, :countries, :territories, :images))

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

  # export xml
  def export_xml
    @movie = Movie.find(params[:id])  # Find the specific movie (same as in show)

    respond_to do |format|
      # just display xml in browser
      format.xml { render "export" }

      # this one makes it download. note the filename you can change!
      # format.xml do
      #   xml_string = render_to_string(template: "movies/export", formats: [ :xml ])
      #   send_data xml_string, filename: "movie_#{@movie.title}.xml", type: "application/xml"
      # end
    end
  end

  # youtube xml
  def yt_xml
    @movie = Movie.find(params[:id])  # Find the specific movie (same as in show)

    respond_to do |format|
      # just display xml in browser
      format.xml { render "yt" }

      # this one makes it download. note the filename you can change!
      # format.xml do
      #   xml_string = render_to_string(template: "movies/yt", formats: [ :xml ])
      #   send_data xml_string, filename: "movie_#{@movie.title}.xml", type: "application/xml"
      # end
    end
  end

  def prepare_bundle
    @movie = Movie.find(params[:id])
    GenerateZipBundleJob.perform_later(@movie)

    respond_to do |format|
      format.html { redirect_to @movie, notice: "Your download is being prepared. Check back shortly!" }
    end
  end

  private
    def create_actors_movies(movie, actors)
      if actors.present?
        # Convert incoming actors string to array of names
        new_actor_names = actors.split(",").map(&:strip)
        # Get existing actor names for this movie
        existing_actor_names = movie.actors.pluck(:name)

        # Add new actors that aren't already associated
        names_to_add = new_actor_names - existing_actor_names
        names_to_add.each do |name|
          movie.actors << Actor.find_or_create_by(name: name)
        end

        # Remove actors that are no longer in the list
        names_to_remove = existing_actor_names - new_actor_names
        movie.actors.where(name: names_to_remove).each do |actor|
          movie.actors.delete(actor)
        end
      end
    end

    def create_genres_movies(movie, genres)
      if genres.present?
        # Convert incoming genres string to array of names
        new_genre_names = genres.split(",").map(&:strip)
        # Get existing genre names for this movie
        existing_genre_names = movie.genres.pluck(:name)

        # Add new genres that aren't already associated
        names_to_add = new_genre_names - existing_genre_names
        names_to_add.each do |name|
          movie.genres << Genre.find_by(name: name)
        end

        # Remove genres that are no longer in the list
        names_to_remove = existing_genre_names - new_genre_names
        movie.genres.where(name: names_to_remove).each do |genre|
          movie.genres.delete(genre)
        end
      end
    end

    def create_countries_movies(movie, countries)
      if countries.present?
        # Convert incoming countries string to array of names
        new_country_codes = countries.split(",").map(&:strip)
        # Get existing country names for this movie
        existing_country_codes = movie.countries.pluck(:code)

        # Add new countries that aren't already associated
        codes_to_add = new_country_codes - existing_country_codes
        codes_to_add.each do |code|
          movie.countries << Country.find_by(code: code)
        end

        # Remove countries that are no longer in the list
        codes_to_remove = existing_country_codes - new_country_codes
        movie.countries.where(code: codes_to_remove).each do |code|
          movie.countries.delete(code)
        end
      end
    end

    def create_movies_territories(movie, territories)
      if territories.present?
        # Convert incoming territories string to array of names
        new_territory_codes = territories.split(",").map(&:strip)
        # Get existing territory names for this movie
        existing_territory_codes = movie.territories.pluck(:code)

        # Add new countries that aren't already associated
        codes_to_add = new_territory_codes - existing_territory_codes
        codes_to_add.each do |code|
          movie.territories << Territory.find_by(code: code)
        end

        # Remove territories that are no longer in the list
        codes_to_remove = existing_territory_codes - new_territory_codes
        movie.territories.where(code: codes_to_remove).each do |code|
          movie.territories.delete(code)
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :amazon_id_override, :actors, :genres, :countries, :territories, :start, :finish, images: [] ])
    end
end
