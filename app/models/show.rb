class Show < ApplicationRecord
  has_many :genres_shows, dependent: :destroy
  has_many :genres, through: :genres_shows
  validates_associated :genres

  has_many :seasons
  has_many :episodes, through: :seasons

  has_one_attached :zip_bundle
  after_destroy :delete_zip_bundle_from_s3

  private
  # purge zip from s3! has_one wont do it automatically!
  def delete_zip_bundle_from_s3
    # Check if there's a zip_bundle attached and purge it
    zip_bundle.purge if zip_bundle.attached?
  end
end
