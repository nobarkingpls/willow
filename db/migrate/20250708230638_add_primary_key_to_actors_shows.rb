class AddPrimaryKeyToActorsShows < ActiveRecord::Migration[8.0]
  def change
    add_column :actors_shows, :id, :primary_key
  end
end
