class CountriesMovie < ApplicationRecord
  belongs_to :movie
  belongs_to :country

  validates_uniqueness_of :movie_id, scope: :country_id
end