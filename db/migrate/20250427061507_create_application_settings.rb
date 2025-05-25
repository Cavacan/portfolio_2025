# frozen_string_literal: true

class CreateApplicationSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :application_settings do |t|
      t.integer :base_notification_hour
      t.integer :base_notification_minute
      t.integer :base_pre_notification_hour
      t.integer :base_pre_notification_minute

      t.timestamps
    end
  end
end
