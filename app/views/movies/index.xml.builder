xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Movies xml feed"
    xml.description "xml feed"
    xml.link movies_url

    @movies.each do |movie|
      xml.item do
        xml.title movie.title
        xml.description movie.id
        xml.pubDate movie.created_at # .to_s(:rfc822)
        xml.link movie_url(movie)
        xml.guid movie_url(movie)
      end
    end
  end
end
