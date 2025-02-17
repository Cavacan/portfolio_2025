class MagicLinksController < ApplicationController
  def portal
    if session[:user_id].present?
      @user = User.find(session[:user_id])
      @schedules = @user.schedules
    else
      @user = nil
      @scheules = []
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user
      session[:id] = user.id
      flash[:notice] = 'ログインしました。'
    else
      flash[:alert] = '指定されたアドレスのアカウントが存在しません。'
    end
    redirect_to magic_link_portal_path
  end
  
  def index
    @user = User.find(session[:user_id])
    if @user
      @schedules = @user.schedules
    else
      flash[:alert] = 'ログインが必要です。'
      redirect_to magic_link_portal_path
    end
  end

  def authenticate
    user = User.find_by(magic_link_token: params[:token])

    if user && user.magic_link_token_end_time >= Time.current
      session[:user_id] = user.id
      flash[:notice] = 'マジックリンクでアクセスしました。'

      if params[:schedule_id].present?
        redirect_to edit_magic_link_schedule_path(schedule_id: params[:schedule_id])
      else
        redirect_to magic_links_index_path
      end
    else
      flash[:alert] = 'リンクが無効か、期限切れです。'
      redirect_to root_path
    end
  end

  def generate
    user = User.find_by(email: params[:email])

    if user
      user.generate_magic_link_token
      UserMailer.send_magic_link(user).deliver_later
      flash[:notice] = 'ログインリンクを送信しました。'

      redirect_to magic_link_portal_path
    else
      flash[:alert] = '指定されたアドレスのアカウントが存在しません。'
      redirect_to magic_link_portal_path
    end
  end
end
