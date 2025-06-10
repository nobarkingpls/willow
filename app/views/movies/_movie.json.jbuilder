json.extract! movie, :id, :title, :start, :finish, :created_at, :updated_at
json.apple_id movie.generate_apple_id
json.genre movie.genres, :name
json.actor movie.actors, :name
json.country movie.countries, :code
json.territory movie.territories, :code
json.image movie.images, :signed_id
json.url movie_url(movie, format: :json)
