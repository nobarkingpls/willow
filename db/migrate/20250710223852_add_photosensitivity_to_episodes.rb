class AddPhotosensitivityToEpisodes < ActiveRecord::Migration[8.0]
  def change
    add_column :episodes, :photosensitivity, :boolean
  end
end
