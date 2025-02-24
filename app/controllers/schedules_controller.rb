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
    if schedule_params[:title].blank? || schedule_params[:notification_period].blank? || schedule_params[:next_notification].blank?
      flash[:alert] = '入力されていない項目があります'
      @schedules = current_user.schedules
      render :index, status: :unprocessable_entity
      return
    elsif schedule_params[:next_notification].present?
      @schedule.after_next_notification = Time.zone.parse(schedule_params[:next_notification]) + schedule_params[:notification_period].to_i.days
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

  def edit
    @schedule = Schedule.find(params[:id])
  end

  def update
    @schedule = Schedule.find(params[:id])
    if @schedule.update(schedule_params)
      @schedule.update_columns(after_next_notification: @schedule.next_notification + @schedule.notification_period.to_i.days)
      UserMailer.send_schedule_change_notification(current_user, @schedule).deliver_now
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
