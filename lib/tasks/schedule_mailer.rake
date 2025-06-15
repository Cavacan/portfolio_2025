# frozen_string_literal: true

require 'schedule_mailer'

namespace :mailer do
  desc 'Check schedules and send notification email to users'
  task send_schedule_notifications: :environment do
    ScheduleMailer.send_notifications
  end

  desc 'send prenotification email to users'
  task send_schedule_pre_notifications: :environment do
    ScheduleMailer.send_pre_notifications
  end
end
