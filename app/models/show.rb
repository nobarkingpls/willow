class Show < ApplicationRecord
  has_many :genres_shows, dependent: :destroy
  has_many :genres, through: :genres_shows
  validates_associated :genres

  has_many :seasons
  has_many :episodes, through: :seasons
end
