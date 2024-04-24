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

ActiveRecord::Schema[7.1].define(version: 2024_04_23_131041) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "guid", null: false
    t.string "redname1"
    t.string "redname2"
    t.string "bluename1"
    t.string "bluename2"
    t.integer "redscore", null: false
    t.integer "bluescore", null: false
    t.string "winner1"
    t.string "winner2"
    t.string "reddiff1"
    t.string "reddiff2"
    t.string "bluediff1"
    t.string "bluediff2"
    t.boolean "is_single", default: false, null: false
    t.boolean "hopping_allowed", default: false, null: false
    t.boolean "game_double", default: false, null: false
    t.boolean "game_boundaries", default: false, null: false
    t.string "game_ex_speed", null: false
    t.string "score_max", null: false
    t.bigint "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "dma", default: false, null: false
    t.string "owner"
    t.index ["season_id"], name: "index_matches_on_season_id"
  end

  create_table "name_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "in_use", default: false, null: false
    t.bigint "user_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_info_id"], name: "index_name_histories_on_user_info_id"
  end

  create_table "seasons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
  end

  create_table "user_infos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "nw_s_win", default: 0, null: false
    t.integer "nw_s_lose", default: 0, null: false
    t.integer "nw_s_rate", default: 0, null: false
    t.integer "ow_s_win", default: 0, null: false
    t.integer "ow_s_lose", default: 0, null: false
    t.integer "ow_s_rate", default: 0, null: false
    t.integer "nw_d_win", default: 0, null: false
    t.integer "nw_d_lose", default: 0, null: false
    t.integer "nw_d_rate", default: 0, null: false
    t.integer "ow_d_win", default: 0, null: false
    t.integer "ow_d_lose", default: 0, null: false
    t.integer "ow_d_rate", default: 0, null: false
    t.bigint "season_id"
    t.bigint "user_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dma_win", default: 0, null: false
    t.integer "dma_lose", default: 0, null: false
    t.integer "dma_rate", default: 0, null: false
    t.index ["season_id"], name: "index_users_on_season_id"
    t.index ["user_info_id"], name: "index_users_on_user_info_id"
  end

end
