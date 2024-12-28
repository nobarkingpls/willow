class AddPrimaryKeyToGenresMovie < ActiveRecord::Migration[8.0]
  def change
    add_column :genres_movies, :id, :primary_key
  end
end
