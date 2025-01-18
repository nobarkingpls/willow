class AddNameToCountries < ActiveRecord::Migration[8.0]
  def change
    add_column :countries, :name, :string
  end
end
