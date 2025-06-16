# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class SchedulesController < ApplicationController
  before_action :require_login
  before_action :set_schedule, except: %i[index create notification complete]

  def index
    schedules = current_user.schedules
    @schedules = schedules.where(status: [1, 2]).order(:next_notification)
    @schedules_archived = schedules.where(status: 0)
    @schedule = Schedule.new

    respond_to do |format|
      format.html
      format.pdf { export_pdf(@schedules) }
    end
  end

  def edit
    @suggested_period = @schedule.suggested_period
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @schedule = Schedule.new(schedule_params.merge(creator: current_user))
    @schedule.set_after_next_notification

    unless @schedule.valid?
      flash.now[:alert] = '入力されていない項目があります'
      @schedules = current_user.schedules
      return render :index, status: :unprocessable_entity
    end

    if @schedule.save
      flash[:notice] = '予定を作成しました。'
      redirect_to schedules_path
    else
      flash[:alert] = '予定の作成に失敗しました。'
      @schedules = current_user.schedules
      render :index, status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/AbcSize

  def update
    if @schedule.update(schedule_params)
      @schedule.force_update_after_notification!
      UserMailer.send_schedule_change_notification(current_user, @schedule).deliver_now
      redirect_after_action('予定を変更しました。')
    else
      flash[:alert] = '編集に失敗しました。'
      render :edit
    end
  end

  def archive
    # 表示用ビュー
  end

  def archive_complete
    if @schedule.update(
      next_notification: @schedule.next_notification + 100.years,
      after_next_notification: @schedule.after_next_notification + 100.years,
      status: 0
    )
      redirect_after_action('予定をアーカイブ化しました。')
    else
      flash[:alert] = '予定のアーカイブ化に失敗しました。'
      render :archive
    end
  end

  def notification
    @schedule = current_user.schedules.find(params[:id])
    UserMailer.send_schedule_notifications(current_user, [@schedule]).deliver_now if @schedule
  end

  def complete
    schedule = Schedule.find_by(id: params[:id], done_token: params[:token])
    unless schedule
      flash[:alert] = 'この完了リンクは無効です。'
      return redirect_to root_path
    end

    schedule.reset_term
    create_notification_log(schedule)

    flash[:notice] = "予定「#{schedule.title}」を完了しました。次回の予定日は#{schedule.next_notification.strftime('%Y/%m/%d')}です。"
    redirect_to root_path
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:title, :notification_period, :next_notification, :price)
  end

  def create_notification_log(schedule)
    NotificationLog.create!(
      schedule_id: schedule.id,
      send_time: Time.zone.today,
      is_snooze: false
    )
  end

  def export_pdf(schedules)
    pdf = SchedulesPdf.new(schedules)
    send_data pdf.render,
              filename: "schedules_#{Time.current.strftime('%Y%m%d%H%M%S')}.pdf",
              type: 'application/pdf',
              disposition: 'attachment'
  end

  def redirect_after_action(message)
    flash[:notice] = message
    redirect_to current_user.admin? ? admin_dashboard_path : schedules_path
  end
end

# rubocop:enable Metrics/ClassLength
