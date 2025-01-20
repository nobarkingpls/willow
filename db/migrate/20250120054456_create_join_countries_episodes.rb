class CreateJoinCountriesEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_join_table :countries, :episodes do |t|
      t.index [ :episode_id, :country_id ]
      t.index [ :country_id, :episode_id ]
    end
  end
end
