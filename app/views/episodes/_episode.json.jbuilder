json.extract! episode, :id, :title, :start, :finish, :created_at, :updated_at
json.country episode.countries, :code
json.url episode_url(episode, format: :json)
