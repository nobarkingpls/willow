class CreateJoinMoviesTerrrtories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :movies, :territories do |t|
      t.index [ :territory_id, :movie_id ]
      t.index [ :movie_id, :territory_id ]
    end
  end
end
