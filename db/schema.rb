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

ActiveRecord::Schema[8.1].define(version: 2026_08_06_123638) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "list_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_bookmarks_on_list_id"
    t.index ["movie_id"], name: "index_bookmarks_on_movie_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.text "summary"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "x"
    t.integer "y"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "citizens", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_citizens_on_category_id"
  end

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "citizen_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["citizen_id"], name: "index_messages_on_citizen_id"
  end

  create_table "movies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "overview"
    t.string "poster_url"
    t.decimal "rating"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_notes_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "tile_map", default: [], array: true
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "lists"
  add_foreign_key "bookmarks", "movies"
  add_foreign_key "categories", "users"
  add_foreign_key "citizens", "categories"
  add_foreign_key "messages", "citizens"
  add_foreign_key "notes", "categories"
end
