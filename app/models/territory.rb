class Territory < ApplicationRecord
  has_many :movies_territories
  has_many :movies, through: :movies_territories

  validates :name, uniqueness: true
end
