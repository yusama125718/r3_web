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

ActiveRecord::Schema[7.1].define(version: 2024_03_01_081853) do
  create_table "doubles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "redname1"
    t.string "redname2"
    t.string "bluename1"
    t.string "bluename2"
    t.integer "redscore"
    t.integer "bluescore"
    t.string "winner1"
    t.string "winner2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid"
    t.boolean "hopping_allowed", default: false, null: false
    t.boolean "game_double", default: false, null: false
    t.string "game_ex_speed"
    t.boolean "game_boundaries", default: false, null: false
    t.string "score_max"
  end

  create_table "singles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "redname"
    t.string "bluename"
    t.integer "redscore"
    t.integer "bluescore"
    t.string "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid"
    t.boolean "hopping_allowed", default: false, null: false
    t.boolean "game_double", default: false, null: false
    t.string "game_ex_speed"
    t.boolean "game_boundaries", default: false, null: false
    t.string "score_max"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "single_win"
    t.integer "single_lose"
    t.integer "double_win"
    t.integer "double_lose"
  end

end
