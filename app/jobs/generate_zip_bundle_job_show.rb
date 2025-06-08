require "zip"

class GenerateZipBundleJobShow < ApplicationJob
  queue_as :default

  def perform(show)
    Rails.logger.debug "Processing show: #{show.id}"

    Tempfile.create([ "bundle-", ".zip" ]) do |tempfile|
      Zip::OutputStream.open(tempfile) do |zip|
        # Add show XML
        zip.put_next_entry("show/data.xml")
        zip.write generate_xml_for_show(show)

        # Add show images
        show.images.each do |image|
          if image.filename.to_s.include?("second")
            zip.put_next_entry("show/images/#{image.filename}")
            zip.write image.download
          end
        end

        # Iterate over each season
        show.seasons.includes(:episodes).find_each do |season|
          # Add season XML
          zip.put_next_entry("seasons/#{season.id}/data.xml")
          zip.write generate_xml_for_season(season)

          # Add episode images (optional example)
          season.images.each do |image|
            if image.filename.to_s.include? "second"
              zip.put_next_entry("seasons/#{season.id}/images/#{image.filename}")
              zip.write image.download
            end
          end

          # Iterate over each episode in the season
          season.episodes.each do |episode|
            # Add episode XML
            zip.put_next_entry("seasons/#{season.id}/episodes/#{episode.id}/data.xml")
            zip.write generate_xml_for_episode(episode)

            # Add episode images
            episode.images.each do |image|
              if image.filename.to_s.include? "first"
                zip.put_next_entry("seasons/#{season.id}/episodes/#{episode.id}/images/#{image.filename}")
                zip.write image.download
              end
            end
          end
        end
      end

      tempfile.rewind

      show.zip_bundle.attach(
        io: tempfile,
        filename: "#{show.title.parameterize}-bundle-#{Time.now.to_i}.zip",
        content_type: "application/zip"
      )
    end

    Turbo::StreamsChannel.broadcast_replace_to(
      "zip_bundle_#{show.id}",
      target: "zip_bundle_section",
      partial: "shows/zip_bundle_section",
      locals: { show: show }
    )
  end

  private

  def generate_xml_for_show(show)
    ApplicationController.renderer.render(
      template: "shows/yt",
      formats: [ :xml ],
      assigns: { show: show }
    )
  end

  def generate_xml_for_season(season)
    ApplicationController.renderer.render(
      template: "seasons/yt",
      formats: [ :xml ],
      assigns: { season: season }
    )
  end

  def generate_xml_for_episode(episode)
    ApplicationController.renderer.render(
      template: "episodes/yt",
      formats: [ :xml ],
      assigns: { episode: episode }
    )
  end
end
