class AddPrimaryKeyToCountriesEpisodes < ActiveRecord::Migration[8.0]
  def change
    add_column :countries_episodes, :id, :primary_key
  end
end
