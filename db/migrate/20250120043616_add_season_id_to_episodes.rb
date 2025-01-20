class AddSeasonIdToEpisodes < ActiveRecord::Migration[8.0]
  def change
    add_reference :episodes, :season
  end
end
