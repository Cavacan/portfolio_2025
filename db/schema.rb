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

ActiveRecord::Schema[7.1].define(version: 2025_06_15_181848) do
  create_table "application_settings", force: :cascade do |t|
    t.integer "base_notification_hour"
    t.integer "base_notification_minute"
    t.integer "base_pre_notification_hour"
    t.integer "base_pre_notification_minute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_logs", force: :cascade do |t|
    t.integer "schedule_id", null: false
    t.datetime "send_time"
    t.boolean "is_snooze", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
    t.index ["schedule_id"], name: "index_notification_logs_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "creator_type", null: false
    t.integer "creator_id", null: false
    t.string "title", null: false
    t.integer "notification_period"
    t.datetime "next_notification"
    t.datetime "after_next_notification"
    t.integer "status", default: 1
    t.boolean "check_done", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "done_token"
    t.integer "price"
    t.index ["creator_type", "creator_id"], name: "index_schedules_on_creator"
  end

  create_table "shared_lists", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "list_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shared_lists_on_user_id"
  end

  create_table "shared_lists_schedules", force: :cascade do |t|
    t.integer "shared_list_id", null: false
    t.integer "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_shared_lists_schedules_on_schedule_id"
    t.index ["shared_list_id"], name: "index_shared_lists_schedules_on_shared_list_id"
  end

  create_table "shared_users", force: :cascade do |t|
    t.integer "host_user_id", null: false
    t.integer "shared_list_id", null: false
    t.string "email"
    t.string "initial_password_digest"
    t.integer "status", null: false
    t.string "named_by_shared_user"
    t.string "named_by_host_user"
    t.string "magic_link_token", null: false
    t.datetime "magic_link_token_end_time", null: false
    t.string "old_magic_link_token"
    t.datetime "old_magic_link_token_end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "shared_list_id"], name: "index_shared_users_on_email_and_shared_list_id", unique: true
    t.index ["host_user_id"], name: "index_shared_users_on_host_user_id"
    t.index ["shared_list_id"], name: "index_shared_users_on_shared_list_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "need_check_done", default: false, null: false
    t.boolean "skip_confirmation", default: false, null: false
    t.boolean "skip_pre_notification", default: false, null: false
    t.string "pre_notification_cycle_type"
    t.integer "pre_notification_cycle_day"
    t.integer "notification_hour"
    t.integer "notification_minute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "pre_notification"
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "email_change_token"
    t.datetime "email_change_token_end_time"
    t.string "new_email"
    t.boolean "admin", default: false, null: false
    t.string "magic_link_token"
    t.datetime "magic_link_token_end_time"
    t.string "old_magic_link_token"
    t.datetime "old_magic_link_token_end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "line_user_id"
    t.string "google_user_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_user_id"], name: "index_users_on_google_user_id", unique: true
    t.index ["line_user_id"], name: "index_users_on_line_user_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "notification_logs", "schedules"
  add_foreign_key "shared_lists", "users"
  add_foreign_key "shared_lists_schedules", "schedules"
  add_foreign_key "shared_lists_schedules", "shared_lists"
  add_foreign_key "shared_users", "shared_lists"
  add_foreign_key "shared_users", "users", column: "host_user_id"
  add_foreign_key "user_settings", "users"
end
