class Episode < ApplicationRecord
  belongs_to :season

  has_many :countries_episodes, dependent: :destroy
  has_many :countries, through: :countries_episodes
  validates_associated :countries

  validates :season_id, presence: true
  validates :number, presence: true
end
