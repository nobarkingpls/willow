class SeasonsController < ApplicationController
  before_action :set_season, only: %i[ show edit update destroy ]

  # GET /seasons or /seasons.json
  def index
    @seasons = Season.all

    # search logic
    if params[:show_id].present? and params[:season_id].blank?
      @searched_seasons = Show.find(params[:show_id]).seasons

    elsif params[:season_id].present? and params[:show_id].blank?
      @searched_seasons = Season.where(id: params[:season_id])
    end
  end

  # GET /seasons/1 or /seasons/1.json
  def show
  end

  # GET /seasons/new
  def new
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit
  end

  # POST /seasons or /seasons.json
  def create
    @season = Season.new(season_params.except(:images))

    respond_to do |format|
      if @season.save

        if params[:season][:images].present?
          params[:season][:images].reject(&:blank?).each do |uploaded_file|
            filename = uploaded_file.original_filename

            if filename.include?("first") || filename.include?("second")
              @season.attach_image_with_custom_key(uploaded_file)
            end
          end
        end

        format.html { redirect_to @season, notice: "Season was successfully created." }
        format.json { render :show, status: :created, location: @season }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1 or /seasons/1.json
  def update
    # handle image updates
    if params[:season][:images].present?
      params[:season][:images].reject(&:blank?).each do |uploaded_file|
        # Check if uploaded_file is a file object or a string
        if uploaded_file.respond_to?(:original_filename)
          filename = uploaded_file.original_filename
        else
          filename = uploaded_file # Treat it as a path or string
        end

        if filename.include?("first") || filename.include?("second")
          # Remove existing attachment with matching pattern
          @season.images.each do |image|
            existing_filename = image.filename.to_s
            if existing_filename.include?("first") && filename.include?("first")
              image.purge
            elsif existing_filename.include?("second") && filename.include?("second")
              image.purge
            end
          end

          # Attach the new file
          @season.attach_image_with_custom_key(uploaded_file)
        end
      end
    end

    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to @season, notice: "Season was successfully updated." }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1 or /seasons/1.json
  def destroy
    @season.destroy!

    respond_to do |format|
      format.html { redirect_to seasons_path, status: :see_other, notice: "Season was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # export xml
  def export_xml
    @season = Season.find(params[:id])  # Find the specific episode (same as in show)

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
    @season = Season.find(params[:id])  # Find the specific episode (same as in show)

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
    @season = Season.find(params[:id])
    GenerateZipBundleJobSeason.perform_later(@season)

    # episodes = Episode.where(season_id: @season.id)
    # episodes.each do |episode|
    #   GenerateZipBundleJobEpisode.perform_later(episode)
    # end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @season, notice: "Your download is being prepared. Check back shortly!" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = Season.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def season_params
      params.expect(season: [ :number, :show_id ])
    end
end
