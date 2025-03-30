class Admin::LogsController < Admin::BaseController
  def index
    @q = NotificationLog.ransack(params[:q])
    @logs = @q.result.includes(:schedule).order(created_at: :desc).page(params[:page])
  end
end
