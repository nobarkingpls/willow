class AddStartAndFinishToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :start, :datetime
    add_column :movies, :finish, :datetime
  end
end
