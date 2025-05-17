class SharedUserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def access_link(shared_user)
    @shared_user = shared_user
    @shared_list = @shared_user.shared_list
    @shared_list_title = @shared_list.list_title
    @host_name = @shared_list.user.name.presence || @shared_list.user.email
    @url = shared_user_session_url(id: @shared_user.id, token: @shared_user.magic_link_token)

    @terms_url = terms_url
    @privacy_url = policy_url

    mail(
      to: @shared_user.email,
      subject: "共有リスト:#{@shared_list_title} 【予定通知アプリ】"
    )
  end

  def activated(shared_user)
    @shared_user = shared_user
    @shared_list_title = @shared_user.shared_list.list_title
    @url = shared_user_url(id: @shared_user.id, token: @shared_user.magic_link_token)
    mail(
      to: @shared_user.email,
      subject: "認証成功 【予定通知アプリ】"
    )
  end
end