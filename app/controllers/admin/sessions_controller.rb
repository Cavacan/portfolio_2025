class Admin::SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password])

    if user&.admin?
      flash[:notice] = 'ログインしました。'
      redirect_to admin_dashboard_path
    else
      logout
      flash[:alert] = user.nil? ? 'メールアドレスまたはパスワードが間違っています。' : '管理者権限がありません。'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:notice] = 'ログアウトしました。'
    redirect_to admin_login_path
  end
end
