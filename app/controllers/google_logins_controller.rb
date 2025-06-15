# frozen_string_literal: true

require 'httparty'

class GoogleLoginsController < ApplicationController
  def new
    state = SecureRandom.hex(64)
    session[:google_login_state] = state

    base_url = 'https://accounts.google.com/o/oauth2/v2/auth'
    query = {
      client_id: ENV.fetch('GOOGLE_CLIENT_ID', nil),
      redirect_uri: ENV.fetch('GOOGLE_REDIRECT_URI', nil),
      response_type: 'code',
      scope: 'openid email profile',
      state: state,
      access_type: 'offline',
      prompt: 'consent'
    }.to_query

    redirect_to "#{base_url}?#{query}", allow_other_host: true
  end

  def callback
    return handle_invalid_state if params[:state] != session[:google_login_state]

    user_info = fetch_google_user_info(params[:code])
    return handle_google_login_failure if user_info.blank?

    User.find_by(email: user_info['email'])

    handle_user_login(user_info)
  end

  private

  def handle_invalid_state
    Rails.logger.warn '[GoogleLogin] state mismatch' unless Rails.env.production?
    redirect_to root_path, alert: '不正なアクセスです'
  end

  def fetch_google_user_info(code)
    token_response = HTTParty.post('https://oauth2.googleapis.com/token', {
                                     headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
                                     body: {
                                       code: code,
                                       client_id: ENV.fetch('GOOGLE_CLIENT_ID', nil),
                                       client_secret: ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
                                       redirect_uri: ENV.fetch('GOOGLE_REDIRECT_URI', nil),
                                       grant_type: 'authorization_code'
                                     }
                                   })
    access_token = JSON.parse(token_response.body)['access_token']
    return nil if access_token.blank?

    profile_response = HTTParty.get('https://www.googleapis.com/oauth2/v2/userinfo', {
                                      headers: { 'Authorization' => "Bearer #{access_token}" }
                                    })
    JSON.parse(profile_response.body)
  rescue StandardError => e
    Rails.logger.error "[GoogleLogin] fetch error: #{e.message}"
    nil
  end

  def handle_google_login_failure
    redirect_to root_path, alert: 'Google認証に失敗しました。'
  end

  def handle_user_login(user_info)
    email = user_info['email']
    google_user_id = user_info['id']
    user = User.find_by(email: email)

    if user
      user.update!(google_user_id: google_user_id) if user.google_user_id.blank?
      auto_login(user)
      redirect_to schedules_path, notice: 'Googleログインに成功しました'
    else
      session[:temp_google_user_id] = google_user_id
      session[:email] = email
      flash[:alert] = 'アカウントが存在しません。新しく作成してください。'
      redirect_to new_registration_path
    end
  end
end
