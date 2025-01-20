class AddNumberToEpisodes < ActiveRecord::Migration[8.0]
  def change
    add_column :episodes, :number, :integer
  end
end
