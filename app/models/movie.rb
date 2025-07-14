require "csv"

class Movie < ApplicationRecord
    include HasJoinTableAssociations

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

    has_one_attached :scc
    after_destroy :delete_scc_from_s3

    has_one_attached :zip_bundle
    after_destroy :delete_zip_bundle_from_s3

    has_one_attached :itunes_zip_bundle
    after_destroy :delete_itunes_zip_bundle_from_s3

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

    # scc logic see below also
    def attach_scc_with_custom_key(uploaded_file)
        uploaded_file.tempfile.rewind

        scc.attach(
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

    # csv export - comment or remove at some point!!
    def self.to_csv
        attributes = %w[id]

        CSV.generate(headers: true) do |csv|
            csv << attributes

            all.find_each do |movie|
            csv << attributes.map { |attr| movie.send(attr) }
            end
        end
    end

    private

    # direct file to s3 folder
    def custom_s3_key(filename)
        ext = File.extname(filename).downcase
        base = File.basename(filename, ext)
        uuid = SecureRandom.uuid

        # not actually checking file types here o.o just extensions!
        case ext
        when ".scc"
          "#{Rails.env}/movies/scc/#{base}-#{uuid}#{ext}"
        when ".png"
          if filename.include?("test")
            "#{Rails.env}/movies/test-folder/#{base}-#{uuid}#{ext}"
          elsif filename.include?("second")
            "#{Rails.env}/movies/second-folder/#{base}-#{uuid}#{ext}"
          else
            nil # do i handle nil i can't remember?
          end
        else
          nil
        end
    end

    # purge zip from s3! has_one wont do it automatically!
    def delete_zip_bundle_from_s3
        # Check if there's a zip_bundle attached and purge it
        zip_bundle.purge if zip_bundle.attached?
    end

    # purge itunes zip from s3! has_one wont do it automatically!
    def delete_itunes_zip_bundle_from_s3
        # Check if there's a itunes zip_bundle attached and purge it
        itunes_zip_bundle.purge if itunes_zip_bundle.attached?
    end

    # purge scc s3! has_one wont do it automatically!
    # # test this pls!! -- works :)
    def delete_scc_from_s3
        # Check if there's a scc attached and purge it
        scc.purge if scc.attached?
    end
end
