# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171206172721) do

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "discipline"
    t.integer "player_type", null: false
    t.integer "max_teams"
    t.integer "game_mode", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "startdate"
    t.date "enddate"
    t.date "deadline"
    t.integer "gameday_duration"
    t.integer "owner_id"
    t.index ["game_mode"], name: "index_events_on_game_mode"
    t.index ["owner_id"], name: "index_events_on_owner_id"
    t.index ["player_type"], name: "index_events_on_player_type"
  end

  create_table "events_teams", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "team_id", null: false
    t.index ["event_id", "team_id"], name: "index_events_teams_on_event_id_and_team_id"
    t.index ["team_id", "event_id"], name: "index_events_teams_on_team_id_and_event_id"
  end

  create_table "events_users", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "user_id", null: false
    t.index ["event_id", "user_id"], name: "index_events_users_on_event_id_and_user_id"
    t.index ["user_id", "event_id"], name: "index_events_users_on_user_id_and_event_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "place"
    t.integer "score_home"
    t.integer "score_away"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_home_id"
    t.integer "team_away_id"
    t.integer "event_id"
    t.integer "points_home"
    t.integer "points_away"
    t.integer "gameday"
    t.string "team_home_type", default: "Team"
    t.string "team_away_type", default: "Team"
    t.index ["event_id"], name: "index_matches_on_event_id"
  end

  create_table "organizers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "event_id"
    t.index ["event_id"], name: "index_organizers_on_event_id"
    t.index ["user_id"], name: "index_organizers_on_user_id"
  end

  create_table "team_users", id: false, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.boolean "is_owner"
    t.index ["user_id", "team_id"], name: "index_team_users_on_user_id_and_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "kind_of_sport"
    t.boolean "private"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "uid"
    t.text "image_data"
    t.boolean "admin", default: false
    t.date "birthday"
    t.string "telephone_number"
    t.string "telegram_username"
    t.string "favourite_sports"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
