json.extract! movie, :id, :title, :start, :finish, :created_at, :updated_at
json.genre movie.genres, :id, :name
json.actor movie.actors, :name
json.country movie.countries, :code
json.url movie_url(movie, format: :json)
