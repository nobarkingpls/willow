class Genre < ApplicationRecord
    has_many :genres_movies
    has_many :movies, through: :genres_movies
    validates :name, uniqueness: true
end
