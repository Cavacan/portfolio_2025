# frozen_string_literal: true

class SharedList < ApplicationRecord
  belongs_to :user
  has_many :shared_lists_schedules, dependent: :destroy
  has_many :schedules, through: :shared_lists_schedules
  has_many :shared_users, dependent: :destroy
end
