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

  xml.episodes do
    @episodes.each do |episode|
      xml.episode do
        xml.title episode.title
        xml.start episode.start.in_time_zone.strftime("%Y-%m-%d %H:%M:%S %:z")
        xml.finish episode.finish.in_time_zone.strftime("%Y-%m-%d %H:%M:%S %:z")
        # xml.description movie.description
        # Add any other movie attributes you want to include
      end
    end
  end
end
