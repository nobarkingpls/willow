require "zip"

class GenerateItunesZipBundleJobSeason < ApplicationJob
  queue_as :default

  def perform(season)
    Rails.logger.debug "Processing season: #{season.id}"

    # Create a Tempfile for the zip
    Tempfile.create([ "bundle-", ".zip" ]) do |tempfile|
      Zip::OutputStream.open(tempfile) do |zip|
        # Add all episode XMLs from season
        season.episodes.each do |episode|
          zip.put_next_entry("#{episode.id}.itmsp/metadata.xml")
          zip.write generate_xml_for(episode)
        end
      end

      tempfile.rewind

      # Attach the zip to the ep
      season.itunes_zip_bundle.attach(
        io: tempfile,
        filename: "itunes-bundle-#{Time.now.to_i}.zip",
        content_type: "application/zip"
      )
    end

    # Broadcast a Turbo Stream update
    Turbo::StreamsChannel.broadcast_replace_to(
      "zip_bundle_#{season.id}",
      target: "zip_bundle_section",
      partial: "seasons/zip_bundle_section",
      locals: { season: season }
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
