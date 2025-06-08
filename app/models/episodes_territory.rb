class EpisodesTerritory < ApplicationRecord
  belongs_to :territory
  belongs_to :episode

  validates_uniqueness_of :episode_id, scope: :territory_id
end
