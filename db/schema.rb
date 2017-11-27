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

ActiveRecord::Schema.define(version: 20171124121138) do

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "discipline"
    t.integer "player_type", null: false
    t.integer "max_teams"
    t.integer "game_mode", null: false
    t.integer "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "startdate"
    t.date "enddate"
    t.date "deadline"
    t.index ["game_mode"], name: "index_events_on_game_mode"
    t.index ["player_type"], name: "index_events_on_player_type"
  end

  create_table "matches", force: :cascade do |t|
    t.date "date"
    t.string "place"
    t.integer "score_home"
    t.integer "score_away"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_home_id"
    t.integer "team_away_id"
  end

  create_table "organizers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "event_id"
    t.index ["event_id"], name: "index_organizers_on_event_id"
    t.index ["user_id"], name: "index_organizers_on_user_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
