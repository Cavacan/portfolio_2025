namespace :mailer do
  desc 'Check schedules and send notification email to users'
  task send_schedule_notifications: :environment do
    today = Date.today
    users = User.joins(:schedules)
                .where('DATE(schedules.next_notification) = ?', today)
                .distinct

    users.find_each do |user| # user毎に実行
      schedules = user.schedules.where(next_notification: today.beginning_of_day..today.end_of_day)

      if schedules.any?
        UserMailer.send_schedule_notifications(user, schedules).deliver_later
        puts "送信完了： #{user.email}"

        schedules.each do |schedule|
          NotificationLog.create!(
            schedule_id: schedule.id,
            send_time: schedule.next_notification,
            is_snooze: false
          )

          next_date = schedule.next_notification + schedule.notification_period.days
          after_next_date = schedule.after_next_notification + schedule.notification_period.days

          schedule.update!(
            next_notification: next_date,
            after_next_notification: after_next_date
          )
        end
      else
        puts '送信が必要な当日予定なし。'
      end
    end
  end
end
