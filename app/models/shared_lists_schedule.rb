# frozen_string_literal: true

class SharedListsSchedule < ApplicationRecord
  belongs_to :shared_list
  belongs_to :schedule
end
