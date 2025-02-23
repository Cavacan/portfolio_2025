class Admin::SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password])
    if user 
      flash[:notice] = 'ログインしました。'
      redirect_to admin_dashboard_index_path
    else
      logout
      flash[:alert] = '管理者権限がありません。'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    falsh[:notice] = 'ログアウトしました。'
    redirect_to admin_login_path
  end
end
