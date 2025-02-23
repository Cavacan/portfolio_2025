class Schedule < ApplicationRecord
  belongs_to :creator, polymorphic: true
  validates :title, presence: true
  validates :notification_period, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :next_notification, presence: true
end
