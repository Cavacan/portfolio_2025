# frozen_string_literal: true

class SharedUsersController < ApplicationController
  def show
    @shared_user = SharedUser.find(params[:id])
    if @shared_user.nil? || @shared_user.magic_link_token != params[:token]
      redirect_to root_path, alert: '認証に失敗しました。'
      return
    elsif @shared_user.revoked?
      flash[:alert] = '共有が解除されているためリストにアクセスできません。'
      redirect_to unshared_path
    end
    session[:shared_user_id] = @shared_user.id unless session[:shared_user_id] == @shared_user.id

    @shared_list = @shared_user.shared_list
    @schedules = @shared_list.schedules.order(:next_notification)
  end

  def create
    shared_list = current_user.shared_lists.find(params[:shared_user][:shared_list_id])
    shared_user = shared_list.shared_users.build(shared_user_params)
    shared_user.host_user = current_user
    shared_user.status = :pending
    shared_user.generate_first_magic_link_token

    if shared_user.save
      SharedUserMailer.access_link(shared_user).deliver_now
      flash[:notice] = '共有リンクを送信しました。'
    else
      flash[:alert] = '追加に失敗しました。'
    end
    redirect_to edit_shared_list_path(shared_list)
  end

  def complete_schedule
    shared_user = SharedUser.find(params[:id])
    shared_list = shared_user.shared_list
    schedule =  shared_list.schedules.find_by(id: params[:schedule_id])

    schedule.update!(
      next_notification: Time.zone.today + schedule.notification_period.days,
      after_next_notification: Time.zone.today + (2 * schedule.notification_period.days)
    )

    SharedUserMailer.complete_schedule(shared_user, schedule).deliver_later
    SharedUserMailer.complete_schedule_self(shared_user, schedule).deliver_later
    NotificationLog.create!(
      schedule_id: schedule.id,
      send_time: Time.zone.today,
      is_snooze: false
    )
    flash[:notice] = '予定を完了させ、次回予定日を設定しました。'
    redirect_to shared_user_path(shared_user, token: shared_user.magic_link_token)
  end

  def destroy
    shared_user = SharedUser.find(params[:id])
    if shared_user.update(status: :revoked)
      SharedUserMailer.unshared_to_host(shared_user).deliver_later
      SharedUserMailer.unshared_to_shared_user(shared_user).deliver_later
      flash[:notice] = '共有を解除しました。ご利用ありがとうございました。'
      redirect_to unshared_path
    else
      flash[:alert] = '共有の解除に失敗しました。'
      redirect_to shared_user_path(shared_user, token: shared_user.magic_link_token)
    end
  end

  def unshared; end

  private

  def shared_user_params
    params.require(:shared_user).permit(:email, :named_by_host_user, :shared_list_id)
  end
end
