class CreateJoinGenresShows < ActiveRecord::Migration[8.0]
  def change
    create_join_table :genres, :shows do |t|
      t.index [ :show_id, :genre_id ]
      t.index [ :genre_id, :show_id ]
    end
  end
end
