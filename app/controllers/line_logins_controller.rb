# frozen_string_literal: true

require 'httparty'

class LineLoginsController < ApplicationController
  def new
    state = SecureRandom.hex(64)
    session[:line_login_state] = state
    redirect_to "https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=#{ENV['LINE_CHANNEL_ID']}&redirect_uri=#{ENV['LINE_REDIRECT_URI']}&state=#{state}&scope=profile%20openid", allow_other_host: true
  end

  def callback
    if params[:state] != session[:line_login_state]
      redirect_to root_path, alert: '不正なアクセスです'
      return
    end

    response = HTTParty.post("https://api.line.me/oauth2/v2.1/token", {
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: {
        grant_type: 'authorization_code',
        code: params[:code],
        redirect_uri: ENV['LINE_REDIRECT_URI'],
        client_id: ENV['LINE_CHANNEL_ID'],
        client_secret: ENV['LINE_CHANNEL_SECRET']
      }
    })

    access_token = JSON.parse(response.body)['access_token']
    profile = HTTParty.get("https://api.line.me/v2/profile", {
      headers: { 'Authorization' => "Bearer #{access_token}" }
    })

    line_user_id = JSON.parse(profile.body)['userId']
    user = User.find_by(line_user_id: line_user_id)

    if user
      login_user(user)
    else
      session[:line_user_id] = line_user_id
      flash[:alert] = 'アプリのアカウントが存在しません。アカウントを作成してください。'
      redirect_to new_registration_path
    end
  end

  private

  def login_user(user)
    auto_login(user)
    redirect_to schedules_path, notice: 'LINEログインに成功しました'
  end
end
