class ActorsEpisode < ApplicationRecord
  belongs_to :episode
  belongs_to :actor

  validates_uniqueness_of :episode_id, scope: :actor_id
end
