class AddShowIdToSeasons < ActiveRecord::Migration[8.0]
  def change
    add_reference :seasons, :show
  end
end
