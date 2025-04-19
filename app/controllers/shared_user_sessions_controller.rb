class SharedUserSessionsController < ApplicationController
  def show
    shared_user = SharedUser.find_by(id: params[:id])

    if shared_user&.token_valid?(params[:token])
      session[:shared_user_id] = shared_user.id
      flash[:notice] = '共有ユーザーの認証に成功しました'
      redirect_to temp_path
    else
      render plain: "リンクの有効期限が切れています。新しいリンクを送信しました。"
    end
  end
end