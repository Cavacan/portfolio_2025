class Schedule < ApplicationRecord
  belongs_to :creator, polymorphic: true
end
