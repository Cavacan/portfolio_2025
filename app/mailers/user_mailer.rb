class UserMailer < ApplicationMailer
  def send_registration_mail(user, url)
    @user = user
    @url = url
    mail(to: @user.email, subject: '予定通知アプリ　アカウント作成')
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

  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: 'パスワード再設定')
  end

  def reset_password_completed(user)
    @user = user
    mail(to: user.email, subject: '[重要] パスワードの変更が完了しました。【予定通知アプリ】')
  end

  def email_change_confirmation(user)
    @user = user
    @url = email_confirm_url(@user.email_change_token)
    mail(to: user.email, subject: '【確認】メールアドレス変更手続き')
  end

  def email_change_completed(user)
    @user = user
    mail(to: @user.email, subject: '【通知】メールアドレスの変更が完了しました。')
  end
end
