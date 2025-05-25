# frozen_string_literal: true

class CreateNotificationLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_logs do |t|
      t.references :schedule, null: false, foreign_key: true
      t.datetime :send_time
      t.boolean :is_snooze

      t.timestamps
    end
  end
end
