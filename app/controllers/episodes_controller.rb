class EpisodesController < ApplicationController
  before_action :set_episode, only: %i[ show edit update destroy ]

  # GET /episodes or /episodes.json
  def index
    # Start by defining a scope to fetch episodes
    @episodes = Episode.all

    # Apply search logic with eager loading

    if params[:show_id].present?
      # Fetch the show and its episodes in a single query
      @searched_episodes = Show.includes(seasons: :episodes)
                               .find(params[:show_id])
                               .episodes
    elsif params[:season_id].present? && params[:episode_number].blank?
      # Eager load seasons and episodes
      @searched_episodes = Episode.includes(:season).where(season_id: params[:season_id])
    elsif params[:season_id].present? && params[:episode_number].present?
      # Eager load seasons and episodes, and filter by season and episode number
      @searched_episodes = Episode.includes(:season)
                                   .where(season_id: params[:season_id])
                                   .where(number: params[:episode_number])
    end
  end

  # GET /episodes/1 or /episodes/1.json
  def show
  end

  # GET /episodes/new
  def new
    @episode = Episode.new
  end

  # GET /episodes/1/edit
  def edit
  end

  # POST /episodes or /episodes.json
  def create
    @episode = Episode.new(episode_params.except(:countries, :territories, :images))
    create_countries_episodes(@episode, params[:episode][:countries])
    create_episodes_territories(@episode, params[:episode][:territories])

    respond_to do |format|
      if @episode.save

        if params[:episode][:images].present?
          params[:episode][:images].reject(&:blank?).each do |uploaded_file|
            filename = uploaded_file.original_filename

            if filename.include?("first")
              @episode.attach_image_with_custom_key(uploaded_file)
            end
          end
        end

        format.html { redirect_to @episode, notice: "Episode was successfully created." }
        format.json { render :show, status: :created, location: @episode }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /episodes/1 or /episodes/1.json
  def update
    create_countries_episodes(@episode, params[:episode][:countries])
    create_episodes_territories(@episode, params[:episode][:territories])

    # handle image updates
    if params[:episode][:images].present?
      params[:episode][:images].reject(&:blank?).each do |uploaded_file|
        # Check if uploaded_file is a file object or a string
        if uploaded_file.respond_to?(:original_filename)
          filename = uploaded_file.original_filename
        else
          filename = uploaded_file # Treat it as a path or string
        end

        if filename.include?("first")
          # Remove existing attachment with matching pattern
          @episode.images.each do |image|
            existing_filename = image.filename.to_s
            if existing_filename.include?("first") && filename.include?("first")
              image.purge
            end
          end

          # Attach the new file
          @episode.attach_image_with_custom_key(uploaded_file)
        end
      end
    end

    respond_to do |format|
      if @episode.update(episode_params.except(:countries, :territories))
        format.html { redirect_to @episode, notice: "Episode was successfully updated." }
        format.json { render :show, status: :ok, location: @episode }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /episodes/1 or /episodes/1.json
  def destroy
    @episode.destroy!

    respond_to do |format|
      format.html { redirect_to episodes_path, status: :see_other, notice: "Episode was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # export xml
  def export_xml
    @episode = Episode.find(params[:id])  # Find the specific episode (same as in show)

    respond_to do |format|
      # just display xml in browser
      format.xml { render "export" }

      # this one makes it download. note the filename you can change!
      # format.xml do
      #   xml_string = render_to_string(template: "episodes/export", formats: [ :xml ])
      #   send_data xml_string, filename: "episode_#{@episode.title}.xml", type: "application/xml"
      # end
    end
  end

  # youtube xml
  def yt_xml
    @episode = Episode.find(params[:id])  # Find the specific episode (same as in show)

    respond_to do |format|
      # just display xml in browser
      format.xml { render "yt" }

      # this one makes it download. note the filename you can change!
      # format.xml do
      #   xml_string = render_to_string(template: "episode/yt", formats: [ :xml ])
      #   send_data xml_string, filename: "episode_#{@episode.title}.xml", type: "application/xml"
      # end
    end
  end

  def prepare_bundle
    @episode = Episode.find(params[:id])
    GenerateZipBundleJobEpisode.perform_later(@episode)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @episode, notice: "Your download is being prepared. Check back shortly!" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params.expect(:id))
    end

    def create_countries_episodes(episode, countries)
      if countries.present?
        # Convert incoming countries string to array of names
        new_country_codes = countries.split(",").map(&:strip)
        # Get existing country names for this episode
        existing_country_codes = episode.countries.pluck(:code)

        # Add new countries that aren't already associated
        codes_to_add = new_country_codes - existing_country_codes
        codes_to_add.each do |code|
          episode.countries << Country.find_by(code: code)
        end

        # Remove countries that are no longer in the list
        codes_to_remove = existing_country_codes - new_country_codes
        episode.countries.where(code: codes_to_remove).each do |code|
          episode.countries.delete(code)
        end
      end
    end

    def create_episodes_territories(episode, territories)
      if territories.present?
        # Convert incoming territories string to array of names
        new_territory_codes = territories.split(",").map(&:strip)
        # Get existing territory names for this movie
        existing_territory_codes = episode.territories.pluck(:code)

        # Add new countries that aren't already associated
        codes_to_add = new_territory_codes - existing_territory_codes
        codes_to_add.each do |code|
          episode.territories << Territory.find_by(code: code)
        end

        # Remove territories that are no longer in the list
        codes_to_remove = existing_territory_codes - new_territory_codes
        episode.territories.where(code: codes_to_remove).each do |code|
          episode.territories.delete(code)
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def episode_params
      params.expect(episode: [ :title, :start, :finish, :season_id, :number, :countries, :territories ])
    end
end
