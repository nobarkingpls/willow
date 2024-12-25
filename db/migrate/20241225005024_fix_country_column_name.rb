class FixCountryColumnName < ActiveRecord::Migration[8.0]
  def change
    rename_column :rights, :country, :country_code
  end
end
