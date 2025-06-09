class AddAmazonIdOverrideToSeasons < ActiveRecord::Migration[8.0]
  def change
    add_column :seasons, :amazon_id_override, :string
  end
end
