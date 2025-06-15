# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
    @user = User.new(email: session[:email])
    set_meta_tags(
      title: 'サインイン | 予定通知アプリ',
      description: 'サインインをするとスケジュール通知が使えるようになります。',
      keyword: '予定管理,スケジュール管理,メール通知',
      og: {
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: view_context.image_url('ogp/ogp_default.png')
      },
      twitter: {
        card: 'summary_large_image',
        title: 'サインイン | 予定通知アプリ',
        description: 'サインインをするとスケジュール通知が使えるようになります。',
        image: view_context.image_url('ogp/ogp_twitter.png')
      }
    )
  end

  def edit
    @user = User.find_by(email_change_token: params[:token])

    return unless @user.nil? || @user.email_change_token_end_time < Time.current

    flash[:error] = 'このリンクは無効です'
    redirect_to root_path
  end

  #  パスワード入力用ページへのURLメール送信用（トークン付）
  def create
    return unagreement unless user_params[:agree] == '1'

    session.delete(:email)

    @user = User.find_by(email: user_params[:email])

    if @user
      registered_user
    else
      new_user
    end
    UserMailer.send_registration_mail(@user, @url).deliver_later

    # セキュリティ
    flash[:notice] = 'アカウント作成用のメールを送信しました。'
    redirect_to new_registration_path
  end

  def update
    @user = User.find_by(email_change_token: params[:token])

    return invalid_token unless valid_token?(user)

    if complete_user_registration
      flash[:notice] = 'パスワードが設定されました'
      redirect_to root_path
    else
      flash[:error] = registration_failure_message
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :agree)
  end

  def unagreement
    flash[:alert] = '利用規約の同意が必要です。'
    session[:email] = user_params[:email]
    redirect_to new_registration_path
  end

  def registered_user
    @user.update(email_change_token: SecureRandom.urlsafe_base64, email_change_token_end_time: 1.hour.from_now)
    @url = edit_registration_url(token: @user.email_change_token)
  end

  def new_user
    @user = User.new(user_params)
    @user.email_change_token = SecureRandom.urlsafe_base64
    @user.email_change_token_end_time = 1.hour.from_now

    return unless @user.save(validate: false)

    @url = edit_registration_url(token: @user.email_change_token)
  end

  def valid_token?(user)
    user.present? && user.email_change_token_end_time >= Time.current
  end

  def invalid_token
    flash[:error] = 'このリンクは無効です'
    redirect_to root_path
  end

  def complete_user_registration
    @user.complete_registration!(
      params[:user][:password],
      params[:user][:password_confirmation]
    )
  end

  def registration_failure_message
    "パスワードの設定に失敗しました: #{@user.errors.full_messages.join(', ')}"
  end
end
