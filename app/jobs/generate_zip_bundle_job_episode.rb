require "zip"

class GenerateZipBundleJobEpisode < ApplicationJob
  queue_as :default

  def perform(episode)
    # episode is now an instance of the Episode model
    Rails.logger.debug "Processing episode: #{episode.id}"

    timestamp = Time.now.to_i

    # Create a Tempfile for the zip
    Tempfile.create([ "bundle-", ".zip" ]) do |tempfile|
      Zip::OutputStream.open(tempfile) do |zip|
        # Add XML
        zip.put_next_entry("#{episode.id}-#{timestamp}/data.xml")
        zip.write generate_xml_for(episode)

        # Add images
        episode.images.each do |image|
          # only include image if it has second in the filename
          if image.filename.to_s.include? "first"
            zip.put_next_entry(image.filename.to_s)
            zip.write image.download
          end
        end
      end

      tempfile.rewind

      # Attach the zip to the episode
      episode.zip_bundle.attach(
        io: tempfile,
        filename: "#{episode.title}bundle-#{Time.now.to_i}.zip",
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
      template: "episodes/yt",  # Ensure this path is correct for your view
      formats: [ :xml ],
      assigns: { episode: episode }
    )
  end
end
