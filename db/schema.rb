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

ActiveRecord::Schema[8.1].define(version: 2026_10_04_195200) do
  create_table "saved_tools", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "slug"], name: "index_saved_tools_on_user_id_and_slug", unique: true
    t.index ["user_id"], name: "index_saved_tools_on_user_id"
  end

  create_table "tool_histories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "slug", null: false
    t.string "input_preview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_tool_histories_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_tool_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "display_name", default: "", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "saved_tools", "users"
  add_foreign_key "tool_histories", "users"
end
