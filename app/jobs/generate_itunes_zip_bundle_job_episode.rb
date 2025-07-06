require "zip"

class GenerateItunesZipBundleJobEpisode < ApplicationJob
  queue_as :default

  def perform(episode)
    Rails.logger.debug "Processing episode: #{episode.id}"

    # Create a Tempfile for the zip
    Tempfile.create([ "bundle-", ".zip" ]) do |tempfile|
      Zip::OutputStream.open(tempfile) do |zip|
        # Add XML
        zip.put_next_entry("#{episode.id}.itmsp/metadata.xml")
        zip.write generate_xml_for(episode)
      end

      tempfile.rewind

      # Attach the zip to the ep
      episode.itunes_zip_bundle.attach(
        io: tempfile,
        filename: "itunes-bundle-#{Time.now.to_i}.zip",
        content_type: "application/zip"
      )
    end

    # Broadcast a Turbo Stream update
    Turbo::StreamsChannel.broadcast_replace_to(
      "zip_bundle_#{episode.id}",
      target: "zip_bundle_section",
      partial: "episodes/zip_bundle_section",
      locals: { episode: episode }
    )
  end

  private

  def generate_xml_for(episode)
    ApplicationController.renderer.render(
      template: "episodes/itunes",
      formats: [ :xml ],
      assigns: { episode: episode }
    )
  end
end
