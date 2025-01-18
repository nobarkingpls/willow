class ActorsMovie < ApplicationRecord
  belongs_to :movie
  belongs_to :actor

  validates_uniqueness_of :movie_id, scope: :actor_id
end
