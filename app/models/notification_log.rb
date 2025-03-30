class NotificationLog < ApplicationRecord
  belongs_to :schedule

  def self.ransackable_attributes(auth_object = nil)
    [:schedule_id, :send_time, :updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[schedule]
  end
end
