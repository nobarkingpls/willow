require "zip"

class GenerateZipBundleJobSeason < ApplicationJob
  queue_as :default

  def perform(season)
    Rails.logger.debug "Processing season: #{season.id}"

    Tempfile.create([ "bundle-", ".zip" ]) do |tempfile|
      Zip::OutputStream.open(tempfile) do |zip|
        # Add season XML
        zip.put_next_entry("season/data.xml")
        zip.write generate_xml_for(season)

        # Add season images
        season.images.each do |image|
          if image.filename.to_s.include?("second")
            zip.put_next_entry("season/images/#{image.filename}")
            zip.write image.download
          end
        end

        # Add episode data
        # not sure if this image thing will work but hey here for now
        # season.episodes.includes(:images_attachments, :images_blob).each do |episode|
        season.episodes.each do |episode|
          # Add episode XML
          zip.put_next_entry("episodes/#{episode.id}/data.xml")
          zip.write generate_xml_for_episode(episode)

          # Add episode images
          episode.images.each do |image|
            if image.filename.to_s.include? "first"
              zip.put_next_entry("episodes/#{episode.id}/images/#{image.filename}")
              zip.write image.download
            end
          end
        end
      end

      tempfile.rewind

      season.zip_bundle.attach(
        io: tempfile,
        filename: "#{season.season_title.parameterize}-bundle-#{Time.now.to_i}.zip",
        content_type: "application/zip"
      )
    end

    Turbo::StreamsChannel.broadcast_replace_to(
      "zip_bundle_#{season.id}",
      target: "zip_bundle_section",
      partial: "seasons/zip_bundle_section",
      locals: { season: season }
    )
  end

  private

  def generate_xml_for(season)
    ApplicationController.renderer.render(
      template: "seasons/yt",
      formats: [ :xml ],
      assigns: { season: season }
    )
  end

  def generate_xml_for_episode(episode)
    ApplicationController.renderer.render(
      template: "episodes/yt",  # Make sure this view exists
      formats: [ :xml ],
      assigns: { episode: episode }
    )
  end
end
