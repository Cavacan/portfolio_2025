# frozen_string_literal: true

class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.references :creator, polymorphic: true, null: false
      t.string :title, null: false
      t.integer :notification_period
      t.datetime :next_notification
      t.datetime :after_next_notification
      t.integer :status, default: 1
      t.boolean :check_done

      t.timestamps
    end
  end
end
