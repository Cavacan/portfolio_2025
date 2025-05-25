# frozen_string_literal: true

admin = User.find_by(admin: true)
if admin.nil?
  user = User.find_by(email: 'admin@example.com')

  if user
    user.update!(admin: true)
    Rails.logger.debug { "Admin arleady exist: #{admin.email},and add administrator." }
  else
    user = User.create!(
      email: 'admin@example.com',
      password: 'admin',
      password_confirmation: 'admin',
      admin: true
    )
    Rails.logger.debug { "Admin created: #{user.email}" }
  end
else
  Rails.logger.debug { "Admin already exists: #{admin.email}" }
end

user = User.find_or_create_by!(email: 'user@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
end

Rails.logger.debug { "User created: #{user.email}" }

10.times do
  notification_period = rand(2..31)
  next_notification = Time.zone.today + notification_period
  after_next_notification = next_notification + notification_period

  Schedule.create!(
    creator: user, # creator_type が "User" に自動で設定される
    title: "スケジュール #{rand(1000..9999)}",
    notification_period: notification_period,
    next_notification: next_notification,
    after_next_notification: after_next_notification,
    status: 1
  )
end

Rails.logger.debug { "Schedules created: #{Schedule.count}" }
