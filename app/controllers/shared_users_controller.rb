class SharedUsersController < ApplicationController
  def create
    shared_list = current_user.shared_lists.find(params[:shared_user][:shared_list_id])
    shared_user = shared_list.shared_users.build(shared_user_params)
    shared_user.host_user = current_user
    shared_user.status = :pending
    shared_user.magic_link_token = SecureRandom.urlsafe_base64(32)
    shared_user.magic_link_token_end_time = 1.day.from_now

    if shared_user.save
      SharedUserMailer.access_link(shared_user).deliver_now
      flash[:notice] = '共有リンクを送信しました。'
      redirect_to edit_shared_list_path(shared_list)
    else
      Rails.logger.debug("エラー内容: #{shared_user.errors.full_messages}")
      flash[:alert] = '追加に失敗しました。'
      redirect_to edit_shared_list_path(shared_list)
    end
  end

  private

  def shared_user_params
    params.require(:shared_user).permit(:email, :named_by_host_user, :shared_list_id)
  end
end
