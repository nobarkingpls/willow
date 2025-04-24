class MoviesTerritory < ApplicationRecord
  belongs_to :territory
  belongs_to :movie

  validates_uniqueness_of :movie_id, scope: :territory_id
end
