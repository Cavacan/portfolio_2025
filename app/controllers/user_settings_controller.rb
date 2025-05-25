class UserSettingsController < ApplicationController
  before_action :require_login
  def show
    @user = current_user
    @settings = @user.user_setting
  end

  def check_done
    @settings = current_user.user_setting || current_user.build_user_setting
    if @settings.update(check_done_params)
      flash[:notice] = '設定を変更しました。'
      redirect_to user_setting_path
    else
      flash[:alert] = '設定を変更できませんでした。'
      render :show, status: :unprocessable_entity
    end
  end

  def notification_time
    @settings = current_user.user_setting || current_user.build_user_setting
    if @settings.update(time_params)
      flash[:notice] = '設定を変更しました。'
      redirect_to user_setting_path
    else
      flash[:alert] = '設定を変更できませんでした。'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def check_done_params
    params.require(:user_setting).permit(:need_check_done)
  end

  def time_params
    params.require(:user_setting).permit(:notification_hour, :notification_minute, :pre_notification)
  end
end