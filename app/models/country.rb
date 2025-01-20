class Country < ApplicationRecord
  has_many :countries_movies
  has_many :movies, through: :countries_movies

  has_many :countries_episodes
  has_many :episodes, through: :countries_episodes

  validates :name, uniqueness: true
end
