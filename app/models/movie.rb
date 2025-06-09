class Movie < ApplicationRecord
    has_many :genres_movies, dependent: :destroy
    has_many :genres, through: :genres_movies
    validates_associated :genres

    has_many :actors_movies, dependent: :destroy
    has_many :actors, through: :actors_movies
    validates_associated :actors

    has_many :countries_movies, dependent: :destroy
    has_many :countries, through: :countries_movies
    validates_associated :countries

    has_many :movies_territories, dependent: :destroy
    has_many :territories, through: :movies_territories
    validates_associated :territories

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

    def generate_apple_id
        title.split.map(&:capitalize).join(" ").delete("^a-zA-Z0-9")
    end

    # method for amazon id and override
    def generate_amazon_id(amazon_id_override = nil)
        return amazon_id_override if amazon_id_override.present?

        title.split.map(&:capitalize).join(" ").delete("^a-zA-Z0-9") << "_Movie"
    end

    private

    # direct image to s3 folder
    def custom_s3_key(filename)
        ext = File.extname(filename)
        base = File.basename(filename, ext)
        uuid = SecureRandom.uuid

        if filename.include?("test")
          "#{Rails.env}/movies/test-folder/#{base}-#{uuid}#{ext}"
        elsif filename.include?("second")
          "#{Rails.env}/movies/second-folder/#{base}-#{uuid}#{ext}"
        end
    end

    # purge zip from s3! has_one wont do it automatically!
    def delete_zip_bundle_from_s3
        # Check if there's a zip_bundle attached and purge it
        zip_bundle.purge if zip_bundle.attached?
    end
end
