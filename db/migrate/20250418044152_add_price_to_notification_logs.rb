class AddPriceToNotificationLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :notification_logs, :price, :integer
  end
end
