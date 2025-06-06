class Episode < ApplicationRecord
  belongs_to :season

  has_many :countries_episodes, dependent: :destroy
  has_many :countries, through: :countries_episodes
  validates_associated :countries

  validates :season_id, presence: true
  validates :number, presence: true

  has_one_attached :zip_bundle
  after_destroy :delete_zip_bundle_from_s3

  private
  # purge zip from s3! has_one wont do it automatically!
  def delete_zip_bundle_from_s3
    # Check if there's a zip_bundle attached and purge it
    zip_bundle.purge if zip_bundle.attached?
  end
end
