require "zip"

class GenerateItunesZipBundleJob < ApplicationJob
  queue_as :default

  def perform(movie)
    # movie is now an instance of the Movie model
    Rails.logger.debug "Processing movie: #{movie.id}"

    # Create a Tempfile for the zip
    Tempfile.create([ "bundle-", ".zip" ]) do |tempfile|
      Zip::OutputStream.open(tempfile) do |zip|
        # Add XML
        zip.put_next_entry("#{movie.id}.itmsp/metadata.xml")
        zip.write generate_xml_for(movie)
      end

      tempfile.rewind

      # Attach the zip to the movie
      movie.itunes_zip_bundle.attach(
        io: tempfile,
        filename: "itunes-bundle-#{Time.now.to_i}.zip",
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
      template: "movies/itunes",
      formats: [ :xml ],
      assigns: { movie: movie }
    )
  end
end
