class Schedule < ApplicationRecord
  belongs_to :creator, polymorphic: true

  validates :next_notification, presence: true
  validate :next_notification_must_be_future

  private

  def next_notification_must_be_future
    return if next_notification.blank?
  
    if next_notification <= Time.current
      errors.add(:next_notification, 'は明日以降の日付を指定してください。')
    end
  end
end
