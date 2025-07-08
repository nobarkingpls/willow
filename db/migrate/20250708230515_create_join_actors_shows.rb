class CreateJoinActorsShows < ActiveRecord::Migration[8.0]
  def change
    create_join_table :actors, :shows do |t|
      t.index [ :show_id, :actor_id ]
      t.index [ :actor_id, :show_id ]
    end
  end
end
