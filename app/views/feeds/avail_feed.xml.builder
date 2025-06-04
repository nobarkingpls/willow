xml.instruct!  # Adds XML declaration at the top of the file

xml.feed do
  # Add movies to the XML feed
  xml.movies do
    @movies.each do |movie|
      xml.movie do
        xml.title movie.title
        movie.images.each do |image|
          xml.image image.filename.to_s
        end
        xml.start movie.start.in_time_zone.strftime("%Y-%m-%d %H:%M:%S %:z")
        xml.finish movie.finish.in_time_zone.strftime("%Y-%m-%d %H:%M:%S %:z")
        # xml.description movie.description
        # Add any other movie attributes you want to include
      end
    end
  end

  # Add shows, seasons, and episodes to the XML feed
  xml.shows do
    @shows.each do |show|
      xml.show do
        xml.title show.title
        # xml.description show.description

        xml.seasons do
          show.seasons.each do |season|
            xml.season do
              # xml.title season.title
              xml.number season.number

              xml.episodes do
                season.episodes.each do |episode|
                  xml.episode do
                    xml.title episode.title
                    xml.number episode.number
                    # xml.description episode.description
                    xml.start episode.start.in_time_zone.strftime("%Y-%m-%d %H:%M:%S %:z")
                    xml.finish episode.finish.in_time_zone.strftime("%Y-%m-%d %H:%M:%S %:z")
                    # Add other episode attributes if needed
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
