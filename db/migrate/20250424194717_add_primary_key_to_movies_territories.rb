class AddPrimaryKeyToMoviesTerritories < ActiveRecord::Migration[8.0]
  def change
    add_column :movies_territories, :id, :primary_key
  end
end
