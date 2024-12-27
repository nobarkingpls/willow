class CreateJoinActorsMovies < ActiveRecord::Migration[8.0]
  def change
    create_join_table :actors, :movies do |t|
      t.index [ :movie_id, :actor_id ]
      t.index [ :actor_id, :movie_id ]
    end
  end
end
