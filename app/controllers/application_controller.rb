class ApplicationController < ActionController::Base
  include MetaTags::ControllerHelper
  private

  def not_authenticated
    flash[:notice] = 'ログインして下さい。'
    redirect_to root_path
  end
end
