json.extract! show, :id, :title, :created_at, :updated_at
json.apple_id show.generate_apple_id
json.url show_url(show, format: :json)
