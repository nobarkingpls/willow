class CreateEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_table :episodes do |t|
      t.string :title
      t.datetime :start
      t.datetime :finish

      t.timestamps
    end
  end
end
