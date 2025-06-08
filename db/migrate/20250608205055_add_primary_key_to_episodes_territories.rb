class AddPrimaryKeyToEpisodesTerritories < ActiveRecord::Migration[8.0]
  def change
    add_column :episodes_territories, :id, :primary_key
  end
end
