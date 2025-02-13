class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true

  def complete_registration!(new_password)
    self.password = new_password
    self.email_change_token = nil
    self.email_change_token_end_time = nil
    save
  end
end
