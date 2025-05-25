# frozen_string_literal: true

namespace :mailer do
  desc 'Check schedules and send notification email to users'
  task send_schedule_notifications: :environment do
    today = Time.zone.today
    users = User.joins(:schedules)
                .where('DATE(schedules.next_notification) = ?', today)
                .distinct

    users.find_each do |user| # user毎に実行
      schedules = user.schedules.where(next_notification: today.all_day)

      if schedules.any?
        UserMailer.send_schedule_notifications(user, schedules).deliver_later
        puts "送信完了： #{user.email}"

        schedules.each do |schedule|
          if user.user_settings.need_check_done
            NotificationLog.create!(
              schedule_id: schedule.id,
              send_time: schedule.next_notification,
              price: schedule.price,
              is_snooze: true
            )

            schedule.update!(
              next_notification: Date.tomorrow,
              after_next_notification: Date.tomorrow + 1.day
            )
          else
            NotificationLog.create!(
              schedule_id: schedule.id,
              send_time: schedule.next_notification,
              price: schedule.price,
              is_snooze: false
            )

            schedule.update!(
              next_notification: schedule.next_notification + schedule.notification_period.days,
              after_next_notification: schedule.after_next_notification + schedule.notification_period.days
            )
          end
        end
      else
        puts '送信が必要な当日予定なし。'
      end
    end
  end

  desc 'send prenotification email to users'
  task send_schedule_pre_notifications: :environment do
    today = Time.zone.today

    users = User.joins(:user_setting, :schedules)
                .where(user_settings: { pre_notification: today })
                .distinct

    users.find_each do |user|
      start_date = today + 1.day
      end_date = today + 7.days

      schedules = user.schedules
                      .where(next_notification: start_date.beginning_of_day..end_date.end_of_day)
                      .order(:next_notification)

      if schedules.any?
        hour = user.user_setting.notification_hour || 0
        min = user.user_setting.notification_minute || 0

        send_time = Time.zone.now.change(hour: hour, min: min, sec: 0)
        send_time += 1.hour if send_time < Time.zone.now

        UserMailer.send_schedule_pre_notifications(user, schedules).deliver_later(wait_until: send_time)
        puts "送信予約完了：#{user.email}（#{schedules.count}件）"
      else
        puts "予定なし：#{user.email}"
      end
    end
  end
end
