class CountriesEpisode < ApplicationRecord
  belongs_to :episode
  belongs_to :country

  validates_uniqueness_of :episode_id, scope: :country_id
end
