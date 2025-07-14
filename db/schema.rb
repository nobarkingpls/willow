# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_12_163544) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actors_episodes", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.integer "episode_id", null: false
    t.index ["actor_id", "episode_id"], name: "index_actors_episodes_on_actor_id_and_episode_id"
    t.index ["episode_id", "actor_id"], name: "index_actors_episodes_on_episode_id_and_actor_id"
  end

  create_table "actors_movies", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.integer "movie_id", null: false
    t.index ["actor_id", "movie_id"], name: "index_actors_movies_on_actor_id_and_movie_id"
    t.index ["movie_id", "actor_id"], name: "index_actors_movies_on_movie_id_and_actor_id"
  end

  create_table "actors_shows", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.integer "show_id", null: false
    t.index ["actor_id", "show_id"], name: "index_actors_shows_on_actor_id_and_show_id"
    t.index ["show_id", "actor_id"], name: "index_actors_shows_on_show_id_and_actor_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "countries_episodes", force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "episode_id", null: false
    t.index ["country_id", "episode_id"], name: "index_countries_episodes_on_country_id_and_episode_id"
    t.index ["episode_id", "country_id"], name: "index_countries_episodes_on_episode_id_and_country_id"
  end

  create_table "countries_movies", force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "movie_id", null: false
    t.index ["country_id", "movie_id"], name: "index_countries_movies_on_country_id_and_movie_id"
    t.index ["movie_id", "country_id"], name: "index_countries_movies_on_movie_id_and_country_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.string "title"
    t.datetime "start"
    t.datetime "finish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
    t.integer "number"
    t.string "amazon_id_override"
    t.boolean "photosensitivity"
    t.index ["season_id"], name: "index_episodes_on_season_id"
  end

  create_table "episodes_territories", force: :cascade do |t|
    t.integer "episode_id", null: false
    t.integer "territory_id", null: false
    t.index ["episode_id", "territory_id"], name: "index_episodes_territories_on_episode_id_and_territory_id"
    t.index ["territory_id", "episode_id"], name: "index_episodes_territories_on_territory_id_and_episode_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres_movies", force: :cascade do |t|
    t.integer "genre_id", null: false
    t.integer "movie_id", null: false
    t.index ["genre_id", "movie_id"], name: "index_genres_movies_on_genre_id_and_movie_id"
    t.index ["movie_id", "genre_id"], name: "index_genres_movies_on_movie_id_and_genre_id"
  end

  create_table "genres_shows", force: :cascade do |t|
    t.integer "genre_id", null: false
    t.integer "show_id", null: false
    t.index ["genre_id", "show_id"], name: "index_genres_shows_on_genre_id_and_show_id"
    t.index ["show_id", "genre_id"], name: "index_genres_shows_on_show_id_and_genre_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start"
    t.datetime "finish"
    t.string "amazon_id_override"
    t.boolean "photosensitivity"
    t.string "scc_md5"
  end

  create_table "movies_territories", force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "territory_id", null: false
    t.index ["movie_id", "territory_id"], name: "index_movies_territories_on_movie_id_and_territory_id"
    t.index ["territory_id", "movie_id"], name: "index_movies_territories_on_territory_id_and_movie_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "show_id"
    t.string "amazon_id_override"
    t.index ["show_id"], name: "index_seasons_on_show_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shows", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "amazon_id_override"
  end

  create_table "territories", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_token"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "sessions", "users"
end
