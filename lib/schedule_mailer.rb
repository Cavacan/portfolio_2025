# frozen_string_literal: true

require 'line_notification_service'

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

      LineNotificationService.notify_user(user, schedules) if user.line_user_id.present?
      
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
      schedules = search_schedules(user, today)

      next if schedules.empty?

      deliver_schedule_pre_notifications(user, schedules)
    end
  end

  def log_and_update_schedule(schedule, user)
    is_snooze = user.user_settings.need_check_done

    create_notification_log(schedule, is_snooze)

    if user.user_settings.need_check_done
      schedule.update!(
        next_notification: Date.tomorrow,
        after_next_notification: Date.tomorrow + 1.day
      )
    else
      schedule.update!(
        next_notification: schedule.next_notification + schedule.notification_period.days,
        after_next_notification: schedule.after_next_notification + schedule.notification_period.days
      )
    end
  end

  private

  def search_schedules(user, today)
    start_date = today + 1.day
    end_date = today + 7.days

    user.schedules
        .where(next_notification: start_date.beginning_of_day..end_date.end_of_day)
        .order(:next_notification)
  end

  def deliver_schedule_pre_notifications(user, schedules)
    hour = user.user_setting.notification_hour || 0
    min = user.user_setting.notification_minute || 0
    send_time = Time.zone.now.change(hour: hour, min: min, sec: 0)
    send_time += 1.hour if send_time < Time.zone.now

    UserMailer.send_schedule_pre_notifications(user, schedules).deliver_later(wait_until: send_time)
  end

  def create_notification_log(schedule, is_snooze)
    NotificationLog.create!(
      schedule_id: schedule.id,
      send_time: schedule.next_notification,
      price: schedule.price,
      is_snooze: is_snooze
    )
  end
end
