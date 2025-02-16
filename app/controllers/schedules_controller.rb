class SchedulesController < ApplicationController
  def index
    @schedules = current_user.schedules
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


  private

  def schedule_params
    params.require(:schedule).permit(:title, :notification_period, :next_notification)
  end
end
