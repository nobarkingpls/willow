class AddPrimaryKeyToCountriesMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :countries_movies, :id, :primary_key
  end
end
