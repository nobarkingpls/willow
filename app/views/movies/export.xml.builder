xml.instruct!

xml.movie do
  xml.title @movie.title
  xml.genres do
    @movie.genres.each do |genre|
      xml.genre genre.name
    end
  end
end
