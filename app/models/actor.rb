class Actor < ApplicationRecord
  has_many :actors_movies
  has_many :movies, through: :actors_movies

  has_many :actors_episodes
  has_many :episodes, through: :actors_episodes

  validates :name, uniqueness: true
end
