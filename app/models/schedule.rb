class Schedule < ApplicationRecord
  before_create :generate_token
  belongs_to :creator, polymorphic: true
  has_many :notification_logs, dependent: :destroy

  validates :title, presence: true
  validates :notification_period, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :next_notification, presence: true
  validate :next_notification_must_be_future

  enum status: { disabled: 0, enabled: 1 }, _prefix: true

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
