class ApplicationSetting < ApplicationRecord
  def self.instance
    first_or_create!(
      base_notification_hour: 0,
      base_notification_minute: 0,
      base_pre_notification_hour: 0,
      base_pre_notification_minute: 0
    )
  end
end
