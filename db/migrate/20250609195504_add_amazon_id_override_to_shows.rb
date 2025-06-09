class AddAmazonIdOverrideToShows < ActiveRecord::Migration[8.0]
  def change
    add_column :shows, :amazon_id_override, :string
  end
end
