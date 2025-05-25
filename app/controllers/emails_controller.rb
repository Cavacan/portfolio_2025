# frozen_string_literal: true

class EmailsController < ApplicationController
  before_action :require_login

  def edit; end

  def update
    new_email = params[:user][:new_email]

    current_user.generate_email_change_token!(new_email)
    UserMailer.email_change_confirmation(current_user).deliver_later
    flash[:notice] = '確認メールを送信しました。'
    redirect_to root_path
  end

  def confirm
    user = User.find_by(email_change_token: params[:token])
    if user&.confirm_email_change!(params[:token])
      UserMailer.email_change_completed(user).deliver_later
      flash[:notice] = 'メールアドレスが変更されました。'
    else
      flash[:alert] = 'トークンが無効または期限切れです。'
    end
    redirect_to root_path
  end
end
