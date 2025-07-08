class Episode < ApplicationRecord
  include HasJoinTableAssociations
  
  belongs_to :season

  has_many :countries_episodes, dependent: :destroy
  has_many :countries, through: :countries_episodes
  validates_associated :countries

  has_many :actors_episodes, dependent: :destroy
  has_many :actors, through: :actors_episodes
  validates_associated :actors

  has_many :episodes_territories, dependent: :destroy
  has_many :territories, through: :episodes_territories
  validates_associated :territories

  validates :season_id, presence: true
  validates :number, presence: true

  has_many_attached :images

  has_one_attached :zip_bundle
  after_destroy :delete_zip_bundle_from_s3

  has_one_attached :itunes_zip_bundle
  after_destroy :delete_itunes_zip_bundle_from_s3s

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

  def generate_apple_id
    season.show_title.split.map(&:capitalize).join(" ").delete("^a-zA-Z0-9") << "s#{season.number}e#{number}"
  end

  # method for amazon id and override
  def generate_amazon_id(amazon_id_override = nil)
      return amazon_id_override if amazon_id_override.present?

      season.show_title.split.map(&:capitalize).join(" ").delete("^a-zA-Z0-9") << "_s#{season.number}_e#{number}"
  end

  private

  # direct image to s3 folder
  def custom_s3_key(filename)
    ext = File.extname(filename)
    base = File.basename(filename, ext)
    uuid = SecureRandom.uuid

    if filename.include?("first")
      "#{Rails.env}/episodes/first-folder/#{base}-#{uuid}#{ext}"
    end
  end

  # purge zip from s3! has_one wont do it automatically!
  def delete_zip_bundle_from_s3
    # Check if there's a zip_bundle attached and purge it
    zip_bundle.purge if zip_bundle.attached?
  end

  # purge itunes zip from s3! has_one wont do it automatically!
  def delete_itunes_zip_bundle_from_s3
    # Check if there's a zip_bundle attached and purge it
    itunes_zip_bundle.purge if itunes_zip_bundle.attached?
  end
end
