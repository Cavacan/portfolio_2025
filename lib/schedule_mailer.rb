# frozen_string_literal: true

module ScheduleMailer
  module_function

  def send_notifications
    today = Time.zone.today
    users = User.joins(:schedules)
                .where('DATE(schedules.next_notification) = ?', today)
                .distinct

    users.find_each do |user| # user毎に実行
      schedules = user.schedules.where(next_notification: today.all_day)

      next if schedules.empty?

      UserMailer.send_schedule_notifications(user, schedules).deliver_later
      schedules.each do |schedule|
        log_and_update_schedule(schedule, user)
      end
    end
  end

  def send_pre_notifications
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

      next if schedules.empty?

      hour = user.user_setting.notification_hour || 0
      min = user.user_setting.notification_minute || 0
      send_time = Time.zone.now.change(hour: hour, min: min, sec: 0)
      send_time += 1.hour if send_time < Time.zone.now

      UserMailer.send_schedule_pre_notifications(user, schedules).deliver_later(wait_until: send_time)
    end
  end

  def log_and_update_schedule(schedule, user)
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
end
