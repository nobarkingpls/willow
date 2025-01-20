class EpisodesController < ApplicationController
  before_action :set_episode, only: %i[ show edit update destroy ]

  # GET /episodes or /episodes.json
  def index
    @episodes = Episode.all
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
    @episode = Episode.new(episode_params.except(:countries))
    create_countries_episodes(@episode, params[:episode][:countries])

    respond_to do |format|
      if @episode.save
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
    respond_to do |format|
      if @episode.update(episode_params.except(:countries))
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

    # Only allow a list of trusted parameters through.
    def episode_params
      params.expect(episode: [ :title, :start, :finish, :season_id, :number, :countries ])
    end
end
