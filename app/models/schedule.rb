# frozen_string_literal: true

class Schedule < ApplicationRecord
  before_create :generate_token
  belongs_to :creator, polymorphic: true
  has_many :notification_logs, dependent: :destroy
  has_many :shared_lists_schedules, dependent: :destroy
  has_many :shared_lists, through: :shared_lists_schedules

  validates :title, presence: true
  validates :notification_period, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :next_notification, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :next_notification_must_be_future

  enum :status, { disabled: 0, enabled: 1 }, prefix: true

  def reset_term
    update!(
      next_notification: Time.zone.today + notification_period.days,
      after_next_notification: Time.zone.today + (2 * notification_period.days)
    )
  end

  # rubocop:disable Rails/SkipsModelValidations
  def force_update_after_notification!
    update_columns(after_next_notification: next_notification + notification_period.days)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def suggested_period
    logs = notification_logs.order(:send_time)
    return nil unless logs.size > 2

    total_days = (logs.last.send_time.to_date - logs.first.send_time.to_date).to_i
    suggested = (total_days / (logs.size - 1)).to_i

    suggested if suggested != notification_period && suggested >= 2
  end

  def set_after_next_notification
    return if next_notification.blank? || notification_period.blank?

    self.after_next_notification = next_notification + notification_period.days
  end

  private

  def next_notification_must_be_future
    return if next_notification.blank?

    return unless next_notification <= Time.current

    errors.add(:next_notification, 'は明日以降の日付を指定してください。')
  end

  def generate_token
    loop do
      token = SecureRandom.hex(10)
      unless Schedule.exists?(done_token: token)
        self.done_token = token
        break
      end
    end
  end
end
