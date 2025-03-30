class RenameNofiticationMinuteToNotificationMinuteInUserSettings < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_settings, :nofitication_minute, :notification_minute
  end
end
