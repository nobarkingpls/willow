class DropRights < ActiveRecord::Migration[8.0]
  def change
    drop_table :rights
  end
end
