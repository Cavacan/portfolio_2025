class UserMailer < ApplicationMailer
  def send_mail(user, url)
    @user = user
    @url = url
    mail(to: @user.email, subject: "予定通知アプリ　アカウント作成")
  end
end
