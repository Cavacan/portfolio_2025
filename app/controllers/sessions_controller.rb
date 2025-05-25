class SessionsController < ApplicationController
  def new
    set_meta_tags(
      title: 'ログイン | 予定通知アプリ',
      description: 'スケジュールを管理するにはログインして下さい。',
      og: {
        title: 'ログイン | 予定通知アプリ',
        description: 'スケジュールを管理するにはログインして下さい。',
        type: 'website',
        url: request.original_url,
        image: view_context.image_url('ogp/ogp_default.png')
      },
      twitter: {
        card: 'summary_large_image',
        title: 'ログイン | 予定通知アプリ',
        description: 'スケジュールを管理するにはログインして下さい。',
        image: view_context.image_url('ogp/ogp_default.png')
      }
    )
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.crypted_password.nil?
      flash.now[:alert] = '登録を完了させて下さい。'
      render 'home/index', status: :unprocessable_entity
      return
    end

    @user = login(params[:email], params[:password])

    if @user
      flash[:notice] = 'ログインに成功しました。'
      redirect_to schedules_path
    else
      flash.now[:alert] = 'ログインに失敗しました。'
      Rails.logger.debug "ログインに失敗しました: email=#{params[:email]}, password=#{params[:password]}"
      render 'home/index', status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:notice] = 'ログアウトしました。'
    redirect_to root_path
  end
end
