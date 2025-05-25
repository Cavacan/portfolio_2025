# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :schedules, as: :creator, dependent: :destroy
  has_one :user_setting, dependent: :destroy
  has_many :shared_lists
  has_many :shared_users_as_host, class_name: 'SharedUser', foreign_key: 'host_user_id'

  attr_accessor :agree

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: lambda {
    new_record? || changes[:crypted_password].present?
  }, allow_nil: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password].present? }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  def complete_registration!(new_password, password_confirmation)
    self.password = new_password
    self.password_confirmation = password_confirmation
    self.email_change_token = nil
    self.email_change_token_end_time = nil
    save
  end

  def generate_magic_link_token
    self.magic_link_token = SecureRandom.urlsafe_base64
    self.magic_link_token_end_time = 2.days.from_now
    save!
  end

  def restore_magic_link_token!
    update!(magic_link_token: nil, magic_link_token_end_time: nil)
  end

  def generate_email_change_token!(new_email)
    self.new_email = new_email
    self.email_change_token = SecureRandom.urlsafe_base64
    self.email_change_token_end_time = 1.day.from_now
    save!
  end

  def confirm_email_change!(token)
    return false if token != email_change_token
    return false if email_change_token_end_time < Time.current

    self.email = new_email
    self.new_email = nil
    self.email_change_token = nil
    self.email_change_token_end_time = nil
    save!
  end
end
