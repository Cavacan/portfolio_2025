class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :schedules, as: :creator, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password].present? }, allow_nil: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password].present? }

  def complete_registration!(new_password)
    self.password = new_password
    self.email_change_token = nil
    self.email_change_token_end_time = nil
    save
  end

  def generate_magic_link_token
    self.magic_link_token = SecureRandom.urlsafe_base64
    self.magic_link_token_end_time = Time.current + 2.days
    save!
  end

  def restore_magic_link_token!
    update!(magic_link_token: nil, magic_link_token_end_time: nil)
  end
end
