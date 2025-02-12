class CreateUserSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :need_check_done
      t.boolean :skip_confirmation
      t.boolean :skip_pre_notification
      t.string :pre_notification_cycle_type
      t.integer :pre_notification_cycle_day
      t.integer :notification_hour
      t.integer :nofitication_minute

      t.timestamps
    end
  end
end
