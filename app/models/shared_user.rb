# frozen_string_literal: true

class SharedUser < ApplicationRecord
  belongs_to :host_user, class_name: 'User'
  belongs_to :shared_list

  validates :email, presence: true, uniqueness: { scope: :shared_list_id }
  validates :status, presence: true
  validates :magic_link_token, presence: true
  validates :magic_link_token_end_time, presence: true

  enum :status, { pending: 0, active: 1, revoked: 2 }
  def token_valid?(token)
    magic_link_token == token && magic_link_token_end_time.future?
  end

  def generate_first_magic_link_token
    self.magic_link_token = SecureRandom.urlsafe_base64(32)
    self.magic_link_token_end_time = 1.day.from_now
  end

  def generate_magic_link_token
    self.magic_link_token = SecureRandom.urlsafe_base64(32)
    self.magic_link_token_end_time = 14.days.from_now
  end
end
