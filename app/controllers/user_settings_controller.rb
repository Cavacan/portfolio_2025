class UserSettingsController < ApplicationController
  before_action :require_login
  def show
    @user = current_user
    @settings = @user.user_setting
  end

  def update
    @settings = current_user.user_setting || current_user.build_user_setting
    if @settings.update(settings_params)
      flash[:notice] = '設定を変更しました。'
      redirect_to user_setting_path
    else
      flash[:alert] = '設定を変更できませんでした。'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:user_setting).permit(:need_check_done, :notification_hour, :notification_minute, :pre_notification)
  end
end