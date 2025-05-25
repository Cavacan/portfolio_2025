FactoryBot.define do
  factory :schedule do
    title { 'test予定' }
    notification_period { 3 }
    next_notification { Time.zone.today + 1.day }
    after_next_notification { next_notification + notification_period.days }
    status { 1 }
    association :creator, factory: :user
  end
end
