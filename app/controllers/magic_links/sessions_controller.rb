# frozen_string_literal: true

module MagicLinks
  class SessionsController < ApplicationController
    def login
      user = User.find_by(email: params[:email])

      if user
        session[:user_id] = user.id
        flash[:notice] = 'ログインしました。'
      else
        flash[:alert] = '指定されたアドレスのアカウントが存在しません。'
      end
      redirect_to magic_link_portal_path
    end

    def generate
      user = User.find_by(email: params[:email])

      if user
        user.generate_magic_link_token
        UserMailer.send_magic_link(user).deliver_later
        flash[:notice] = 'ログインリンクを送信しました。'
      else
        flash[:alert] = '指定されたアドレスのアカウントが存在しません。'
      end
      redirect_to magic_link_portal_path
    end

    def authenticate
      user = User.find_by(magic_link_token: params[:token])

      if user && user.magic_link_token_end_time >= Time.current
        session[:user_id] = user.id
        flash[:notice] = 'マジックリンクでアクセスしました。'
        if params[:schedule_id].present?
          redirect_to edit_magic_link_schedule_path(schedule_id: params[:schedule_id])
        else
          redirect_to magic_links_index_path
        end
      else
        flash[:alert] = 'リンクが無効か、期限切れです。'
        redirect_to root_path
      end
    end
  end
end
