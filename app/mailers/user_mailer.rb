class UserMailer < ApplicationMailer
  def send_registration_mail(user, url)
    @user = user
    @url = url
    mail(to: @user.email, subject: "予定通知アプリ　アカウント作成")
  end

  def send_schedule_notifications(user, schedules)
    @user = user
    @schedules = schedules
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

  def send_magic_link_schedule(user, schedule)
    @user = user
    @schedule = schedule
    mail(to: user.email, subject: '新規予定を作成しました。（未ログイン状態）')
  end

  def send_magic_link_schedule_change(user, schedule)
    @user = user
    @schedule = schedule
    mail(to: user.email, subject: '予定を更新しました。（未ログイン状態）')
  end
end
