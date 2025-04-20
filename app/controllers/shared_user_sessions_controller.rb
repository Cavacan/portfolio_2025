class SharedUserSessionsController < ApplicationController
  def show
    shared_user = SharedUser.find_by(id: params[:id])

    if shared_user&.token_valid?(params[:token])
      session[:shared_user_id] = shared_user.id
      shared_user.update(status: :active)
      flash[:notice] = '共有ユーザーの認証に成功しました'
      redirect_to temp_path
    elsif shared_user.present?
      shared_user.generate_magic_link_token
      shared_user.save!
      SharedUserMailer.access_link(shared_user).deliver_now
      render plain: "リンクの有効期限が切れています。新しいリンクを送信しました。"
    else
      render plain: "リンクが無効です。", status: :not_found
    end
  end
end