class MagicLinksController < ApplicationController
  def portal
    if session[:user_id].present?
      @user = User.find(session[:user_id])
      @schedules = @user.schedules
    else
      @user = nil
      @schedules = []
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user
      session[:user_id] = user.id
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
      @schedule = Schedule.new
    else
      flash[:alert] = 'ログインが必要です。'
      redirect_to magic_link_portal_path
    end
  end

  def create_schedule
    @user = User.find(session[:user_id])
    @schedule = Schedule.new(schedule_params)
    @schedule.creator = @user
    
    if schedule_params[:next_notification].present?
      @schedule.after_next_notification = Time.zone.parse(schedule_params[:next_notification]) + schedule_params[:notification_period].to_i.days rescue nil
    end

    if @schedule.save
      UserMailer.send_magic_link_schedule(@user, @schedule).deliver_later
      flash[:notice] = 'マジックリンクで新規予定を作成しました。'
      redirect_to magic_links_index_path
    else
      @schedules = @user.schedules
      flash[:alert] = '予定の作成に失敗しました。'
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/information") }
        format.html { render :index }
      end
    end
  end

  def edit_schedule
    @user = User.find(session[:user_id])
    @schedule = @user.schedules.find_by(id: params[:id])

    if @schedule.nil?
      flash[:alert] = '指定された予定が見つかりません。'
      redirect_to magic_links_index_path
    end
  end

  def update_schedule
    @user = User.find(session[:user_id])
    @schedule = @user.schedules.find_by(id: params[:id])

    if @schedule.update(schedule_params)
      @schedule.update_columns(after_next_notification:  @schedule.next_notification + @schedule.notification_period.to_i.days)
      UserMailer.send_magic_link_schedule_change(@user, @schedule).deliver_later
      flash[:notice] = 'マジックリンクで予定を変更しました。'
      redirect_to magic_links_index_path
    else
      flash[:alert] = '編集に失敗しました。'
      render :edit_schedule
    end
  end

  def magic_link_logout
    logout
    flash[:notice] = 'ログアウトしました。'
    redirect_to magic_link_portal_path
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

  private

  def schedule_params
    params.require(:schedule).permit(:title, :notification_period, :next_notification)
  end
end
