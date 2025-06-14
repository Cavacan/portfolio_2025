# frozen_string_literal: true

class SharedUserSessionsController < ApplicationController
  def show
    shared_user = SharedUser.find(params[:id])

    return render_invalid_link if shared_user.nil?

    return render_revoked if shared_user.revoked?

    if shared_user.token_valid?(params[:token])
      authenticate_shared_user(shared_user)
    else
      resend_expired_link(shared_user)
    end
  end

  private

  def render_invalid_link
    render plain: 'リンクが無効です。', status: :not_found
  end

  def render_revoked
    render plain: '共有は許可されていません。', status: :forbidden
  end

  def authenticate_shared_user(shared_user)
    session[:shared_user_id] = shared_user.id

    if shared_user.pending?
      shared_user.update!(status: :active)
      shared_user.generate_magic_link_token
      shared_user.save!
      SharedUserMailer.activated(shared_user).deliver_later
      flash[:notice] = '共有ユーザーの認証に成功しました'
    end

    redirect_to shared_user_path(shared_user, token: shared_user.magic_link_token)
  end

  def resend_expired_link(shared_user)
    shared_user.generate_first_magic_link_token
    shared_user.save!
    SharedUserMailer.access_link(shared_user).deliver_now
    render plain: 'リンクの有効期限が切れています。新しいリンクを送信しました。'
  end
end
