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

ActiveRecord::Schema[7.1].define(version: 2025_02_11_200016) do
  create_table "user_settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "need_check_done"
    t.boolean "skip_confirmation"
    t.boolean "skip_pre_notification"
    t.string "pre_notification_cycle_type"
    t.integer "pre_notification_cycle_day"
    t.integer "notification_hour"
    t.integer "nofitication_minute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "email_change_token"
    t.string "email_change_token_end_time"
    t.string "new_email"
    t.boolean "admin"
    t.string "magic_link_token"
    t.datetime "magic_link_token_end_time"
    t.string "old_magic_link_token"
    t.datetime "old_magic_link_token_end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_settings", "users"
end
