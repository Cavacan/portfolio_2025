class Signin02Controller < ApplicationController
  def new
  end

  def create
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end

end
