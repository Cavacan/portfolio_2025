class LogsController < ApplicationController
  def index
    @logs = NotificationLog.joins(:schedule)
      .where(schedules: { creator_type: "User", creator_id: current_user.id } )
    @chart_data = @logs.group_by_day(:created_at, time_zone: false).count
  end
end
