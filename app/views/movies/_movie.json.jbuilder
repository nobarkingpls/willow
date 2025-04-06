json.extract! movie, :id, :title, :start, :finish, :created_at, :updated_at
json.genre movie.genres, :name
json.actor movie.actors, :name
json.country movie.countries, :code
json.image movie.images, :signed_id
json.url movie_url(movie, format: :json)
