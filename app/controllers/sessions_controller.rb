class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.crypted_password.nil?
      flash[:alert] = '登録を完了させて下さい。'
      render 'home/index'
      return
    end

    Rails.logger.debug "ユーザーが見つかりました: #{user.email}, crypted_password: #{user.crypted_password}"
    @user = login(params[:email], params[:password])

    if @user
      flash[:notice] = 'ログインに成功しました。'
      # redirect_to schedules_index_path
      redirect_to temp_path
    else
      flash[:alert] = 'ログインに失敗しました。'
      Rails.logger.debug "ログインに失敗しました: email=#{params[:email]}, password=#{params[:password]}"
    render 'home/index'
    end
  end

  def destroy
    logout
    flash[:notice] = 'ログアウトしました。'
    redirect_to root_path
  end
end