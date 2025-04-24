class AddNameToTerritories < ActiveRecord::Migration[8.0]
  def change
    add_column :territories, :name, :string
  end
end
