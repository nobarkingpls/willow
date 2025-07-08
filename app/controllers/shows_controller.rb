class ShowsController < ApplicationController
  before_action :set_show, only: %i[ show edit update destroy ]

  # GET /shows or /shows.json
  def index
    @shows = Show.all

    # search logic
    if params[:show_id].present?
      @searched_show = Show.find(params[:show_id])
    end
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
    @show = Show.new(show_params.except(:genres, :actors, :images))
    @show.update_named_associations(:genres, params[:show][:genres])
    @show.update_named_associations(:actors, params[:show][:actors])

    respond_to do |format|
      if @show.save

        if params[:show][:images].present?
          params[:show][:images].reject(&:blank?).each do |uploaded_file|
            filename = uploaded_file.original_filename

            if filename.include?("first") || filename.include?("second")
              @show.attach_image_with_custom_key(uploaded_file)
            end
          end
        end

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
    @show.update_named_associations(:genres, params[:show][:genres])
    @show.update_named_associations(:actors, params[:show][:actors])

    # handle image updates
    if params[:show][:images].present?
      params[:show][:images].reject(&:blank?).each do |uploaded_file|
        # Check if uploaded_file is a file object or a string
        if uploaded_file.respond_to?(:original_filename)
          filename = uploaded_file.original_filename
        else
          filename = uploaded_file # Treat it as a path or string
        end

        if filename.include?("first") || filename.include?("second")
          # Remove existing attachment with matching pattern
          @show.images.each do |image|
            existing_filename = image.filename.to_s
            if existing_filename.include?("first") && filename.include?("first")
              image.purge
            elsif existing_filename.include?("second") && filename.include?("second")
              image.purge
            end
          end

          # Attach the new file
          @show.attach_image_with_custom_key(uploaded_file)
        end
      end
    end

    respond_to do |format|
      if @show.update(show_params.except(:genres, :actors))
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

  # export xml
  def export_xml
    @show = Show.find(params[:id])  # Find the specific episode (same as in show)

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
    @show = Show.find(params[:id])  # Find the specific episode (same as in show)

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
    @show = Show.find(params[:id])
    GenerateZipBundleJobShow.perform_later(@show)

    # per-episode and per season..not needed
    # @show.seasons.find_each do |season|
    #   GenerateZipBundleJobSeason.perform_later(season)
    #   season.episodes.find_each do |episode|
    #     GenerateZipBundleJobEpisode.perform_later(episode)
    #   end
    # end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @show, notice: "Your download is being prepared. Check back shortly!" }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def show_params
      params.expect(show: [ :show_id, :title, :amazon_id_override, :genres, :actors ])
    end
end
