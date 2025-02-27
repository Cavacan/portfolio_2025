admin = User.find_by(admin: true)
if admin.nil?
  user = User.find_by(email: "admin@example.com")
  
  if user
    user.update!(admin: true)
    puts "Admin arleady exist: #{admin.email},and add administrator."
  else
    user = User.create!(
      email: "admin@example.com",
      password: "admin",
      password_confirmation: "admin",
      admin: true
    )
    puts "Admin created: #{user.email}"
  end
else
  puts "Admin already exists: #{admin.email}"
end

user = User.find_or_create_by!(email: "user@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

puts "User created: #{user.email}"

10.times do
  notification_period = rand(2..31)
  next_notification = Date.today + notification_period
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

puts "Schedules created: #{Schedule.count}"