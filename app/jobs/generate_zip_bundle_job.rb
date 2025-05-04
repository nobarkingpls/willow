require "zip"

class GenerateZipBundleJob < ApplicationJob
  queue_as :default

  def perform(movie)
    # movie is now an instance of the Movie model
    Rails.logger.debug "Processing movie: #{movie.id}"

    # Create a Tempfile for the zip
    Tempfile.create([ "bundle-", ".zip" ]) do |tempfile|
      Zip::OutputStream.open(tempfile) do |zip|
        # Add XML
        zip.put_next_entry("data.xml")
        zip.write generate_xml_for(movie)

        # Add images
        movie.images.each do |image|
          # only include image if it has second in the filename
          if image.filename.to_s.include? "second"
            zip.put_next_entry(image.filename.to_s)
            zip.write image.download
          end
        end
      end

      tempfile.rewind

      # Attach the zip to the movie
      movie.zip_bundle.attach(
        io: tempfile,
        filename: "bundle-#{Time.now.to_i}.zip",
        content_type: "application/zip"
      )
    end

    # Broadcast a Turbo Stream update
    Turbo::StreamsChannel.broadcast_replace_to(
      "zip_bundle_#{movie.id}",
      target: "zip_bundle_section",
      partial: "movies/zip_bundle_section",
      locals: { movie: movie }
    )
  end

  private

  def generate_xml_for(movie)
    ApplicationController.renderer.render(
      template: "movies/yt",  # Ensure this path is correct for your view
      formats: [ :xml ],
      assigns: { movie: movie }
    )
  end
end
