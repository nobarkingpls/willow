json.extract! episode, :id, :title, :start, :finish, :created_at, :updated_at
json.apple_id episode.generate_apple_id
json.country episode.countries, :code
json.url episode_url(episode, format: :json)
