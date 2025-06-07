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

        # Iterate over each season
        show.seasons.includes(:episodes).find_each do |season|
          # Add season XML
          zip.put_next_entry("seasons/#{season.id}/data.xml")
          zip.write generate_xml_for_season(season)

          # Iterate over each episode in the season
          season.episodes.each do |episode|
            # Add episode XML
            zip.put_next_entry("seasons/#{season.id}/episodes/#{episode.id}/data.xml")
            zip.write generate_xml_for_episode(episode)
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
