class SharedList < ApplicationRecord
  belongs_to :user
  has_many :shared_lists_schedules
  has_many :schedules, through: :shared_lists_schedules
end
