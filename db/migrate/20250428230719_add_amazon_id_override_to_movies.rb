class AddAmazonIdOverrideToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :amazon_id_override, :string
  end
end
