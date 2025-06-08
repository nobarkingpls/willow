class Show < ApplicationRecord
  has_many :genres_shows, dependent: :destroy
  has_many :genres, through: :genres_shows
  validates_associated :genres

  has_many :seasons
  has_many :episodes, through: :seasons

  has_many_attached :images

  has_one_attached :zip_bundle
  after_destroy :delete_zip_bundle_from_s3

  # image logic see below also
  def attach_image_with_custom_key(uploaded_file)
    uploaded_file.tempfile.rewind

    images.attach(
        io: uploaded_file.tempfile,
        filename: uploaded_file.original_filename,
        content_type: uploaded_file.content_type,
        key: custom_s3_key(uploaded_file.original_filename),
        identify: false
    )
  end

  private
  # purge zip from s3! has_one wont do it automatically!
  def delete_zip_bundle_from_s3
    # Check if there's a zip_bundle attached and purge it
    zip_bundle.purge if zip_bundle.attached?
  end

  # direct image to s3 folder
  def custom_s3_key(filename)
    ext = File.extname(filename)
    base = File.basename(filename, ext)
    uuid = SecureRandom.uuid

    if filename.include?("first")
      "#{Rails.env}/shows/first-folder/#{base}-#{uuid}#{ext}"
    elsif filename.include?("second")
      "#{Rails.env}/shows/second-folder/#{base}-#{uuid}#{ext}"
    end
  end
end
