class ApplicationController < ActionController::Base
  private

  def not_authenticated
    flash[:notice] = 'ログインして下さい。'
    redirect_to root_path
  end
end
