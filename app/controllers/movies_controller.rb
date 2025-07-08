class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    if params[:movie_id].present?
      @searched_movie = Movie.find_by(id: params[:movie_id])
    end

    @movies = Movie.all

    # respond_to do |format|
    #   format.html
    #   format.turbo_stream
    # end
  end

  # GET /movies/1 or /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :show, status: :created, location: @movie }
      format.csv { send_data Movie.to_csv, filename: "movie-#{Date.today}.csv" }
    end
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
    @movie.update_named_associations(:actors, params[:movie][:actors])
    @movie.update_named_associations(:genres, params[:movie][:genres])
    @movie.update_country_code_associations(:countries, params[:movie][:countries])
    @movie.update_country_code_associations(:territories, params[:movie][:territories])

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
    @movie.update_named_associations(:actors, params[:movie][:actors])
    @movie.update_named_associations(:genres, params[:movie][:genres])
    @movie.update_country_code_associations(:countries, params[:movie][:countries])
    @movie.update_country_code_associations(:territories, params[:movie][:territories])

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

  # itunes xml
  # def itunes_xml
  #   @movie = Movie.find(params[:id])  # Find the specific movie (same as in show)

  #   respond_to do |format|
  #     # just display xml in browser
  #     format.xml { render "itunes" }

  #     # this one makes it download. note the filename you can change!
  #     # format.xml do
  #     #   xml_string = render_to_string(template: "movies/itunes", formats: [ :xml ])
  #     #   send_data xml_string, filename: "movie_#{@movie.title}.xml", type: "application/xml"
  #     # end
  #   end
  # end

  def prepare_bundle
    @movie = Movie.find(params[:id])
    GenerateZipBundleJob.perform_later(@movie)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @movie, notice: "Your download is being prepared. Check back shortly!" }
    end
  end

  def prepare_itunes_bundle
    @movie = Movie.find(params[:id])
    GenerateItunesZipBundleJob.perform_later(@movie)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @movie, notice: "Your download is being prepared. Check back shortly!" }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :amazon_id_override, :actors, :genres, :countries, :territories, :start, :finish, images: [] ])
    end
end
