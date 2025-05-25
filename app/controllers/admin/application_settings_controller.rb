# frozen_string_literal: true

module Admin
  class ApplicationSettingsController < ApplicationController
    def edit
      @setting = ApplicationSetting.instance
    end

    def update
      @setting = ApplicationSetting.instance
      if @setting.update(setting_params)
        system('bundle exec whenever --update-crontab --set environment=production')
        flash[:notice] = '設定を変更しました。'
        redirect_to edit_admin_application_setting_path
      else
        flash.now[:alert] = '設定の変更に失敗しました。'
        render :edit
      end
    end

    private

    def setting_params
      params.require(:application_setting).permit(:base_notification_hour, :base_notification_minute,
                                                  :base_pre_notification_hour, :base_pre_notification_minute)
    end
  end
end
