class GenresMovie < ApplicationRecord
    belongs_to :movie
    belongs_to :genre

    validates_uniqueness_of :movie_id, scope: :genre_id
end
