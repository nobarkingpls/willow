class AddPrimaryKeyToActorsEpisode < ActiveRecord::Migration[8.0]
  def change
    add_column :actors_episodes, :id, :primary_key
  end
end
