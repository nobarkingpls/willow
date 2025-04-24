class Movie < ApplicationRecord
    has_many :genres_movies, dependent: :destroy
    has_many :genres, through: :genres_movies
    validates_associated :genres

    has_many :actors_movies, dependent: :destroy
    has_many :actors, through: :actors_movies
    validates_associated :actors

    has_many :countries_movies, dependent: :destroy
    has_many :countries, through: :countries_movies
    validates_associated :countries

    has_many :movies_territories, dependent: :destroy
    has_many :territories, through: :movies_territories
    validates_associated :territories

    has_many_attached :images
end
