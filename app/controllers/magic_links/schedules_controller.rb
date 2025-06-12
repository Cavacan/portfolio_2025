# frozen_string_literal: true

module MagicLinks
  class SchedulesController < ApplicationController
    before_action :set_user

    def index
      if @user
        @schedules = @user.schedules
        @schedule = Schedule.new
      else
        flash[:alert] = 'ログインが必要です。'
        redirect_to magic_link_portal_path
      end
    end

    def create_schedule
      @schedule = build_schedule

      if @schedule.save
        UserMailer.send_magic_link_schedule(@user, @schedule).deliver_later
        flash[:notice] = 'マジックリンクで新規予定を作成しました。'
        redirect_to magic_links_index_path
      else
        @schedules = @user.schedules
        flash[:alert] = '予定の作成に失敗しました。'
        render_create_failure
      end
    end

    def edit_schedule
      @schedule = @user.schedules.find_by(id: params[:id])
      return unless @schedule.nil?

      flash[:alert] = '指定された予定が見つかりません。'
      redirect_to magic_links_index_path
    end

    def update_schedule
      @schedule = @user.schedules.find_by(id: params[:id])

      if @schedule.update(schedule_params)
        update_after_next_notification
        send_update_mail
        flash[:notice] = 'マジックリンクで予定を変更しました。'
        redirect_to magic_links_index_path
      else
        flash[:alert] = '編集に失敗しました。'
        render :edit_schedule
      end
    end

    private

    def set_user
      @user = User.find(session[:user_id])
    end

    def schedule_params
      params.require(:schedule).permit(:title, :notification_period, :next_notification)
    end

    def build_schedule
      schedule = Schedule.new(schedule_params)
      schedule.creator = @user

      return if schedule_params[:next_notification].blank?

      schedule.after_next_notification = begin
        Time.zone.parse(schedule_params[:next_notification]) + schedule_params[:notification_period].to_i.days
      rescue StandardError
        nil
      end
      schedule
    end

    def render_create_failure
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('flash', partial: 'shared/information') }
        format.html { render :index }
      end
    end

    def update_after_next_notification
      unless @schedule.update(
        after_next_notification: @schedule.next_notification + @schedule.notification_period.to_i.days
      )
        flash[:alert] = '通知日時の更新に失敗しました。'
      end
    end

    def send_update_mail
      UserMailer.send_magic_link_schedule_change(@user, @schedule).deliver_later
    end
  end
end
