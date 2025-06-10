json.extract! season, :id, :show_title, :number, :created_at, :updated_at
json.apple_id season.generate_apple_id
json.url season_url(season, format: :json)
