class Admin::DashboardController < Admin::BaseController
 def index
    @users = User.all.includes(:schedules)
  end
end
