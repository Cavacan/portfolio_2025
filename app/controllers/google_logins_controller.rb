# frozen_string_literal: true

require 'httparty'

class GoogleLoginsController < ApplicationController
  def new
    state = SecureRandom.hex(64)
    session[:google_login_state] = state

    base_url = "https://accounts.google.com/o/oauth2/v2/auth"
    query = {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      redirect_uri: ENV['GOOGLE_REDIRECT_URI'],
      response_type: 'code',
      scope: 'openid email profile',
      state: state,
      access_type: 'offline',
      prompt: 'consent'
    }.to_query

    redirect_to "#{base_url}?#{query}", allow_other_host: true
  end

  def callback
    if params[:state] != session[:google_login_state]
      Rails.logger.warn "[GoogleLogin] state mismatch"
      session.delete(:google_login_state)
      return redirect_to root_path, alert: '不正なアクセスです'
    end

    session.delete(:google_login_state)

    token_response = HTTParty.post('https://oauth2.googleapis.com/token', {
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: {
        code: params[:code],
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        redirect_uri: ENV['GOOGLE_REDIRECT_URI'],
        grant_type: 'authorization_code'
      }
    })

    unless token_response.success?
      Rails.logger.error "[GoogleLogin] Token API error: #{token_response.body}"
      return redirect_to root_path, alert: 'Google認証に失敗しました。'
    end

    token_data = JSON.parse(token_response.body)
    access_token = token_data['access_token']

    profile_response = HTTParty.get('https://www.googleapis.com/oauth2/v2/userinfo', {
      headers: { 'Authorization' => "Bearer #{access_token}" }
    })

    unless profile_response.success?
      Rails.logger.error "[GoogleLogin] Profile API error: #{profile_response.body}"
      return redirect_to root_path, alert: 'Googleプロフィール取得に失敗しました。'
    end

    profile_data = JSON.parse(profile_response.body)
    email = profile_data['email']
    google_user_id = profile_data['id']

    user = User.find_by(email: email)

    if user
      user.update!(google_user_id: google_user_id) if user.google_user_id.blank?
      auto_login(user)
      redirect_to schedules_path, notice: 'Googleログインに成功しました'
    else
      session[:temp_google_user_id] = google_user_id
      session[:email] = email
      flash[:alert] = 'アプリのアカウントが存在しません。アカウントを作成してください。'
      redirect_to new_registration_path
    end
  end
end
