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

ActiveRecord::Schema[8.1].define(version: 2026_02_10_173003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "contact_states", force: :cascade do |t|
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.string "from_state", null: false
    t.jsonb "metadata", default: {}
    t.boolean "most_recent", null: false
    t.integer "sort_key", null: false
    t.string "to_state", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id", "most_recent"], name: "index_contact_states_parent_most_recent", unique: true, where: "most_recent"
    t.index ["contact_id", "sort_key"], name: "index_contact_states_parent_sort", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.text "message"
    t.string "name"
    t.string "phone"
    t.integer "reason"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "demos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "jti"
    t.string "last_name"
    t.string "linkedin_url"
    t.string "location"
    t.string "photo_url"
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0
    t.string "title"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contact_states", "contacts"
  add_foreign_key "tasks", "users"
end
