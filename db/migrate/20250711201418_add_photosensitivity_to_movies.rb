class AddPhotosensitivityToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :photosensitivity, :boolean
  end
end
