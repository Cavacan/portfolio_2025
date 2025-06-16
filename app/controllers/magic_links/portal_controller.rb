# マジックリンクの動作確認用ページです。

# frozen_string_literal: true

module MagicLinks
  class PortalController < ApplicationController
    def portal
      if session[:user_id].present?
        @user = User.find(session[:user_id])
        @schedules = @user.schedules
      else
        @user = nil
        @schedules = []
      end
    end

    def magic_link_logout
      logout
      flash[:notice] = 'ログアウトしました。'
      redirect_to root_path
    end
  end
end
