class AddPrimaryKeyToGenresShows < ActiveRecord::Migration[8.0]
  def change
    add_column :genres_shows, :id, :primary_key
  end
end
