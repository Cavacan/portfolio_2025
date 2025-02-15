class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create #  パスワード入力用ページへのURLメール送信用（トークン付）
    @user = User.find_by(email: user_params[:email])

    if @user
      @user.update(email_change_token: SecureRandom.urlsafe_base64, email_change_token_end_time: 1.hour.from_now)
      @url = edit_registration_url(token: @user.email_change_token)
      UserMailer.send_mail(@user, @url).deliver_later
    else
      #  新規ユーザーの場合
      @user = User.new(user_params)
      @user.email_change_token = SecureRandom.urlsafe_base64
      @user.email_change_token_end_time = 1.hour.from_now

      if @user.save(validate: false) # 保存に成功したか
        @url = edit_registration_url(token: @user.email_change_token)
        UserMailer.send_mail(@user, @url).deliver_later
      end
    end
    # セキュリティ
    flash[:notice] = "アカウント作成用のメールを送信しました。"
    redirect_to new_registration_path
  end

  def edit
    @user = User.find_by(email_change_token: params[:token])

    if @user.nil? || @user.email_change_token_end_time < Time.current
      flash[:error] = "このリンクは無効です"
      redirect_to root_path
    end
  end

  def update
    @user = User.find_by(email_change_token: params[:token])

    if @user.nil? || @user.email_change_token_end_time < Time.current
      flash[:error] = "このリンクは無効です"
      redirect_to root_path
      return
    end

    if @user.complete_registration!(params[:user][:password])
      flash[:notice] = "パスワードが設定されました"
      # redirect_to login_path
      redirect_to root_path
    else
      flash[:error] = "パスワードの設定に失敗しました: #{@user.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
