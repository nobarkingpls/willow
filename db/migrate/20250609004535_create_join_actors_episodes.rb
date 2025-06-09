class CreateJoinActorsEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_join_table :actors, :episodes do |t|
      t.index [ :episode_id, :actor_id ]
      t.index [ :actor_id, :episode_id ]
    end
  end
end
