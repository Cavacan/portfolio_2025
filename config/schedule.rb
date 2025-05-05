require File.expand_path("../config/environment", __dir__)

set :output, "#{path}/log/cron.log"
env :PATH, ENV['PATH']

setting = ApplicationSetting.first

hour = setting&.base_notification_hour || 0
minute = setting&.base_notification_minute || 0

every 1.day, at: "#{format('%02d', hour)}:#{format('%02d', minute)}" do
  rake 'mailer:send_schedule_notifications', environment: 'production'
end
