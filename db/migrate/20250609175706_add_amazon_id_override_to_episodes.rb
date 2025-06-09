class AddAmazonIdOverrideToEpisodes < ActiveRecord::Migration[8.0]
  def change
    add_column :episodes, :amazon_id_override, :string
  end
end
