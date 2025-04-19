class SharedUserMailer < ApplicationMailer
  def access_link(shared_user)
    @shared_user = shared_user
    @url = shared_user_session_url(id: @shared_user.id, token: @shared_user.magic_link_token)

    mail(to: @shared_user.email, subject: '共有リストへのアクセスリンク')
  end
end
