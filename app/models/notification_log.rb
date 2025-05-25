# frozen_string_literal: true

class NotificationLog < ApplicationRecord
  belongs_to :schedule

  def self.ransackable_attributes(_auth_object = nil)
    %w[schedule_id send_time updated_at created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[schedule]
  end
end
