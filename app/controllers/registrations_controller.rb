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
    # 規約同意チェック
    unless user_params[:agree] == '1'
      flash[:alert] = '利用規約の同意が必要です。'
      session[:email] = user_params[:email]
      return redirect_to new_registration_path
    end

    session.delete(:email)

    @user = User.find_by(email: user_params[:email])

    if @user # 既存ユーザーの場合
      @user.update(email_change_token: SecureRandom.urlsafe_base64, email_change_token_end_time: 1.hour.from_now)
      @url = edit_registration_url(token: @user.email_change_token)
      UserMailer.send_registration_mail(@user, @url).deliver_later
    else
      #  新規ユーザーの場合
      @user = User.new(user_params)
      @user.email_change_token = SecureRandom.urlsafe_base64
      @user.email_change_token_end_time = 1.hour.from_now

      if @user.save(validate: false) # 保存に成功したか
        @url = edit_registration_url(token: @user.email_change_token)
        UserMailer.send_registration_mail(@user, @url).deliver_later
      end
    end
    # セキュリティ
    flash[:notice] = 'アカウント作成用のメールを送信しました。'
    redirect_to new_registration_path
  end

  def update
    @user = User.find_by(email_change_token: params[:token])

    if @user.nil? || @user.email_change_token_end_time < Time.current
      flash[:error] = 'このリンクは無効です'
      redirect_to root_path
      return
    end

    if @user.complete_registration!(params[:user][:password], params[:user][:password_confirmation])
      flash[:notice] = 'パスワードが設定されました'
      # redirect_to login_path
      redirect_to root_path
    else
      flash[:error] = "パスワードの設定に失敗しました: #{@user.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :agree)
  end
end
