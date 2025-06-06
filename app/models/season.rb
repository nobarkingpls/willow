class Season < ApplicationRecord
  belongs_to :show
  has_many :episodes

  validates :show_id, presence: true

  def show_title
    "#{show.title}"
  end

  def season_title
    "#{show.title} Season #{number}"
  end

  has_one_attached :zip_bundle
  after_destroy :delete_zip_bundle_from_s3

  private
  # purge zip from s3! has_one wont do it automatically!
  def delete_zip_bundle_from_s3
    # Check if there's a zip_bundle attached and purge it
    zip_bundle.purge if zip_bundle.attached?
  end
end
