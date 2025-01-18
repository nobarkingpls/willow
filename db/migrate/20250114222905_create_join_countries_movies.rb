class CreateJoinCountriesMovies < ActiveRecord::Migration[8.0]
  def change
    create_join_table :countries, :movies do |t|
      t.index [ :movie_id, :country_id ]
      t.index [ :country_id, :movie_id ]
    end
  end
end
