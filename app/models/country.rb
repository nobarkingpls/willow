class Country < ApplicationRecord
  has_many :countries_movies
  has_many :movies, through: :countries_movies
  validates :name, uniqueness: true
end
