class Admin::DashboardController < ApplicationController
  before_action :require_login
  before_action :check_admin

  def index
    @users = User.all.includes(:schedules)
  end

  private

  def not_authenticated
    flash[:alert] = 'ログインして下さい。'
    redirect_to admin_login_path
  end

  def check_admin
    return if current_user.admin?

    flash[:alert] = '管理者権限がありません。'
    redirect_to admin_login_path
  end
end
