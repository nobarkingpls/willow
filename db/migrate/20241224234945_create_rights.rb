class CreateRights < ActiveRecord::Migration[8.0]
  def change
    create_table :rights do |t|
      t.string :country
      t.datetime :start
      t.datetime :end
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
