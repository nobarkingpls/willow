class CreateJoinTableEpisodesTerritories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :episodes, :territories do |t|
      t.index [ :territory_id, :episode_id ]
      t.index [ :episode_id, :territory_id ]
    end
  end
end
