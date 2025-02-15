class SchedulesController < ApplicationController
  def index
    @schedules = current_user.schedules
  end

  def new
    @schedule = User.new
  end
end
