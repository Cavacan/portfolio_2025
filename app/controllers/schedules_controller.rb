class SchedulesController < ApplicationController
  def index
    schedules = current_user.schedules
    @schedules = schedules.where(status: [1, 2])
    @schedules_archived = schedules.where(status: 0)
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.creator = current_user
    @schedule.after_next_notification = Time.zone.parse(schedule_params[:next_notification]) + schedule_params[:notification_period].to_i.days

    if @schedule.save
      flash[:notice] = '予定を作成しました。'
      redirect_to schedules_path
    else
      flash[:alert] = '予定の作成に失敗しました。'
      render :new
    end
  end

  def edit
    @schedule = Schedule.find(params[:id])
  end

  def update
    @schedule = Schedule.find(params[:id])
    @schedule.after_next_notification = Time.zone.parse(schedule_params[:next_notification]) + schedule_params[:notification_period].to_i.days
    if @schedule.update(schedule_params)
      flash[:notice] = '予定を変更しました。'
      redirect_to schedules_path
    else
      flash[:alert] = '編集に失敗しました。'
      render :edit
    end
  end

  def archive
    @schedule = Schedule.find(params[:id])
  end

  def archive_complete
    @schedule = Schedule.find(params[:id])
    if @schedule.update(
      next_notification: @schedule.next_notification + 100.years,
      after_next_notification: @schedule.after_next_notification + 100.years,
      status: 0
    )
      flash[:notice] = '予定をアーカイブ化しました。'
      redirect_to schedules_path
    else
      flash[:alert] = '予定のアーカイブ化に失敗しました。'
      render :archive
    end
  end

  def notification
    @schedule = current_user.schedules.find(params[:id])
    if @schedule
      UserMailer.send_schedule_notifications(current_user, [@schedule] ).deliver_now
    else
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:title, :notification_period, :next_notification)
  end
end
