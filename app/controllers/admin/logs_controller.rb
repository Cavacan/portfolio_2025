class Admin::LogsController < Admin::BaseController
  require 'csv'

  def index
    @q = NotificationLog.ransack(params[:q])
    @logs = @q.result.includes(:schedule).order(created_at: :desc)

    respond_to do |format|
      format.html do
        @logs = @logs.page(params[:page])
      end
      format.csv do
        send_data generate_csv(@logs),
                  filename: "nortification_logs_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv"
      end
    end
  end

  private

  def generate_csv(logs)
    CSV.generate(headers: true) do |csv|
      csv << %w[ID タイトル 周期 送信日時 作成日時 更新日時]

      logs.each do |log|
        csv << [
          log.id,
          log.schedule_id,
          log.schedule.title,
          log.send_time.strftime('%yY/%m/%d %Y:%M'),
          log.created_at.strftime('%yY/%m/%d %Y:%M'),
          log.updated_at.strftime('%yY/%m/%d %Y:%M')
        ]
      end
    end
  end
end
