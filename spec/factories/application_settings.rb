FactoryBot.define do
  factory :application_setting do
    base_notification_hour { 1 }
    base_notification_minute { 1 }
    base_pre_notification_hour { 1 }
    base_pre_notification_minute { 1 }
  end
end
