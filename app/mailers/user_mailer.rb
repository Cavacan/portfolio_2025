class UserMailer < ApplicationMailer
  def send_registration_mail(user, url)
    @user = user
    @url = url
    mail(to: @user.email, subject: "予定通知アプリ　アカウント作成")
  end

  def send_schedule_notifications(user, schedules)
    @user = user
    @schedules = schedules
    schedule_id = schedules.size == 1 ? schedules.first.id : nil
    @magic_link = if schedule_id
                    magic_link_authenticate_url(token: user.magic_link_token, schedule_id: schedule_id)
                  else
                    magic_link_authenticate_url(token: user.magic_link_token)
                  end

    mail(to: @user.email, subject: '予定通知')
  end

  def send_schedule_change_notification(user, schedule)
    @user = user
    @schedule = schedule
    mail(to: @user.email, subject: '予定変更通知')
  end

  def send_magic_link(user)
    @user = user
    @magic_link = magic_link_authenticate_url(token: user.magic_link_token)

    mail(to: user.email, subject: 'ログイン用マジックリンク')
  end

  def send_schedule_magic_link(user, schedule)
    @user = user
    @schedule = schedule
    mail(to: user.email, subject: '新規予定を作成しました。（未ログイン状態）')
  end
end
