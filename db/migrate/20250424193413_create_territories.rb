class CreateTerritories < ActiveRecord::Migration[8.0]
  def change
    create_table :territories do |t|
      t.string :code

      t.timestamps
    end
  end
end
