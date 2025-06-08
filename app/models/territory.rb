class Territory < ApplicationRecord
  has_many :movies_territories
  has_many :movies, through: :movies_territories

  has_many :episodes_territories
  has_many :episodes, through: :episodes_territories

  validates :name, uniqueness: true
end
