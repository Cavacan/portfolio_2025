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

ActiveRecord::Schema[7.1].define(version: 2025_03_30_152407) do
  create_table "notification_logs", force: :cascade do |t|
    t.integer "schedule_id", null: false
    t.datetime "send_time"
    t.boolean "is_snooze"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "check_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "done_token"
    t.index ["creator_type", "creator_id"], name: "index_schedules_on_creator"
  end

  create_table "user_settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "need_check_done"
    t.boolean "skip_confirmation"
    t.boolean "skip_pre_notification"
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
    t.boolean "admin"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "notification_logs", "schedules"
  add_foreign_key "user_settings", "users"
end
