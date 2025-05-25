# frozen_string_literal: true

module Admin
  class DashboardController < Admin::BaseController
    def index
      @users = User.includes(:schedules)
    end
  end
end
