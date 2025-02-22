class User < ApplicationRecord
  authenticates_with_sorcery!

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
end
