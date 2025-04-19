class SharedUser < ApplicationRecord
  belongs_to :host_user, class_name: 'User'
  belongs_to :shared_list

  validates :email, presence: true, uniqueness: { scope: :shared_list_id }
  validates :status, presence: true
  validates :magic_link_token, presence: true
  validates :magic_link_token_end_time, presence: true

  enum status: { pending: 0, active: 1, revoked: 2 }
  def token_valid?(token)
    self.magic_link_token == token && magic_link_token_end_time.future?
  end
end
