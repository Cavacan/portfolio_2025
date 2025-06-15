# frozen_string_literal: true

class FixBooleanDefaults < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :admin, from: nil, to: false
    change_column_null :users, :admin, false

    change_column_default :user_settings, :need_check_done, from: nil, to: false
    change_column_null :user_settings, :need_check_done, false

    change_column_default :user_settings, :skip_confirmation, from: nil, to: false
    change_column_null :user_settings, :skip_confirmation, false

    change_column_default :user_settings, :skip_pre_notification, from: nil, to: false
    change_column_null :user_settings, :skip_pre_notification, false

    change_column_default :schedules, :check_done, from: nil, to: false
    change_column_null :schedules, :check_done, false

    change_column_default :notification_logs, :is_snooze, from: nil, to: false
    change_column_null :notification_logs, :is_snooze, false
  end
end
