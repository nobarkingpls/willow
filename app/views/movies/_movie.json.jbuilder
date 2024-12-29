json.extract! movie, :id, :title, :created_at, :updated_at
json.genre movie.genres, :id, :name
json.actor movie.actors, :name
json.right movie.rights, :country_code, :start, :end
json.url movie_url(movie, format: :json)
