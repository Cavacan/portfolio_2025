# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    set_meta_tags(
      title: 'ログイン | 予定通知アプリ',
      description: 'スケジュールを管理するにはログインして下さい。',
      keyword: '予定管理,スケジュール管理,メール通知',
      og: {
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: view_context.image_url('ogp/ogp_default.png')
      },
      twitter: {
        card: 'summary_large_image',
        title: 'ログイン | 予定通知アプリ',
        description: 'スケジュールを管理するにはログインして下さい。',
        image: view_context.image_url('ogp/ogp_twitter.png')
      }
    )
  end

  def create
    user = User.find_by(email: params[:email])

    if complete_registration?(user)
      flash.now[:alert] = '登録を完了させて下さい。'
      render 'home/index', status: :unprocessable_entity
      return
    end

    @user = login(params[:email], params[:password])

    @user ? login_success : login_failure
  end

  def destroy
    logout
    flash[:notice] = 'ログアウトしました。'
    redirect_to root_path
  end

  private

  def complete_registration?(user)
    user && user.crypted_password.nil?
  end

  def login_success
    flash[:notice] = 'ログインに成功しました。'
    redirect_to schedules_path
  end

  def login_failure
    flash.now[:alert] = 'ログインに失敗しました。'
    render 'home/index', status: :unprocessable_entity
  end
end
