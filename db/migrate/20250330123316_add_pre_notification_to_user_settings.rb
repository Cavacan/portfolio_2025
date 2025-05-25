# frozen_string_literal: true

class AddPreNotificationToUserSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :user_settings, :pre_notification, :datetime
  end
end
