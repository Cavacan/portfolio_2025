# frozen_string_literal: true

require 'httparty'

class LineLoginsController < ApplicationController
  def new
    state = SecureRandom.hex(64)
    session[:line_login_state] = state
    base_url = 'https://access.line.me/oauth2/v2.1/authorize'
    query = {
      response_type: 'code',
      client_id: ENV.fetch('LINE_CHANNEL_ID', nil),
      redirect_uri: ENV.fetch('LINE_REDIRECT_URI', nil),
      state: state,
      scope: 'profile openid email'
    }.to_query
    redirect_to "#{base_url}?#{query}", allow_other_host: true
  end

  def callback
    return handle_invalid_state if params[:state] != session[:line_login_state]

    line_user_id, line_user_email = fetch_line_user_id_email(params[:code])
    user = line_email_login(line_user_email, line_user_id) || User.find_by(line_user_id: line_user_id)
    return handle_line_login_failure unless user

    if user
      login_user(user)
    else
      session[:line_user_id] = line_user_id
      flash[:alert] = 'アプリのアカウントが存在しません。アカウントを作成してください。'
      redirect_to new_registration_path
    end
  end

  private

  def handle_line_login_failure
    redirect_to root_path, alert: 'LINE認証に失敗しました。'
  end

  def login_user(user)
    auto_login(user)
    redirect_to schedules_path, notice: 'LINEログインに成功しました'
  end

  def handle_invalid_state
    redirect_to root_path, alert: '不正なアクセスです'
  end

  def fetch_line_user_id_email(code)
    token_response = HTTParty.post('https://api.line.me/oauth2/v2.1/token', {
                                    headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
                                    body: {
                                      grant_type: 'authorization_code',
                                      code: code,
                                      redirect_uri: ENV.fetch('LINE_REDIRECT_URI', nil),
                                      client_id: ENV.fetch('LINE_CHANNEL_ID', nil),
                                      client_secret: ENV.fetch('LINE_CHANNEL_SECRET', nil)
                                    }
                                  })

    body = JSON.parse(token_response.body)
    access_token = body['access_token']
    id_token = body['id_token']
    return [nil, nil] unless access_token && id_token

    profile_response = HTTParty.get('https://api.line.me/v2/profile', {
                                      headers: { 'Authorization' => "Bearer #{access_token}" }
                                    })

    line_user_id = JSON.parse(profile_response.body)['userId']
    line_user_email = JWT.decode(id_token, nil, false).first['email']
    [line_user_id, line_user_email]
  rescue StandardError => e
    Rails.logger.warn("LINE認証エラー: #{e.message}")
    [nil, nil]
  end


  def line_email_login(line_user_email, line_user_id)
    user = User.find_by(email: line_user_email) 
    return nil unless user

    user.update(line_user_id: line_user_id) if user.line_user_id.blank?
    user
  end
end
