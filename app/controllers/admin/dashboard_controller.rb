class Admin::DashboardController < ApplicationController
  def index
    @users = User.all.includes(:schedules)
  end
end
