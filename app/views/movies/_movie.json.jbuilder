json.extract! movie, :id, :title, :created_at, :updated_at
json.genre movie.genres, :id, :name
json.url movie_url(movie, format: :json)
