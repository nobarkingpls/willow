class AddPrimaryKeyToActorsMovie < ActiveRecord::Migration[8.0]
  def change
    add_column :actors_movies, :id, :primary_key
  end
end
