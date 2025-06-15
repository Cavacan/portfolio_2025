# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class SchedulesController < ApplicationController
  before_action :set_schedule, except: %i[index notification complete]
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
    logs = @schedule.notification_logs.order(:send_time)
    return unless logs.size > 2

    total_days = (logs.last.send_time.to_date - logs.first.send_time.to_date).to_i
    suggested = (total_days / (logs.size - 1)).to_i

    return unless suggested != @schedule.notification_period && suggested >= 2

    @suggested_period = suggested
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @schedule = Schedule.new(schedule_params.merge(creator: current_user))

    if @schedule.valid?
      flash.now[:alert] = '入力されていない項目があります'
      @schedules = current_user.schedules
      return render :index, status: :unprocessable_entity
    end

    @schedule.set_after_next_notification

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
      flash[:notice] = '予定を変更しました。'
      if current_user.admin?
        redirect_to admin_dashboard_path
      else
        redirect_to schedules_path
      end
    else
      flash[:alert] = '編集に失敗しました。'
      render :edit
    end
  end

  def archive; end

  def archive_complete
    if @schedule.update(
      next_notification: @schedule.next_notification + 100.years,
      after_next_notification: @schedule.after_next_notification + 100.years,
      status: 0
    )
      flash[:notice] = '予定をアーカイブ化しました。'
      if current_user.admin?
        redirect_to admin_dashboard_path
      else
        redirect_to schedules_path
      end
    else
      flash[:alert] = '予定のアーカイブ化に失敗しました。'
      render :archive
    end
  end

  def notification
    @schedule = current_user.schedules.find(params[:id])
    return unless @schedule

    UserMailer.send_schedule_notifications(current_user, [@schedule]).deliver_now
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

  # rubocop:disable Rails/SkipsModelValidations
  def force_update_after_notification!
    update_columns(after_next_notification: next_notification + notification_period.days)
  end
  # rubocop:enable Rails/SkipsModelValidations

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
end

# rubocop:enable Metrics/ClassLength
