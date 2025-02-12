class Signin01Controller < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_params[:email]) || User.new(user_params)
    if @user.new_record?
      if @user.save
        @url = url_for(signin02_new_path)
        UserMailer.send_mail(@user, @url).deliver_later
      else
        Rails.logger.debug "User save failed: #{@user.errors.full_messages.join(', ')}"
        flash[:error] = "ユーザーの作成に失敗しました: #{@user.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    else
      # 既存ユーザーの場合はメールだけ送信
      @url = url_for(signin02_new_path)
      UserMailer.send_mail(@user, @url).deliver_later
    end

    flash[:notice] = "アカウント作成用のメールを送信しました。"
    redirect_to signin01_new_path
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
