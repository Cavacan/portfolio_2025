# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  def new; end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    not_authenticated if @user.blank?
  end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    flash[:notice] = 'メール送信しました。'
    redirect_to root_path
  end

  def update
    @user = User.load_from_reset_password_token(params[:id])
    return invalid_token unless @user

    assign_passwords

    if @user.save
      UserMailer.reset_password_completed(@user).deliver_later
      flash[:notice] = 'パスワードを更新しました。'
      redirect_to root_path
    else
      flash.now[:alert] = '再入力のパスワードが一致しません。'
      render :edit
    end
  end

  private

  def invalid_token
    flash.now[:alert] = '無効なトークンです。再度メール送信からやり直して下さい。'
    render :new
  end

  def assign_passwords
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end
end
