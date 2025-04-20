class SharedUsersController < ApplicationController
  def create
    shared_list = current_user.shared_lists.find(params[:shared_user][:shared_list_id])
    shared_user = shared_list.shared_users.build(shared_user_params)
    shared_user.host_user = current_user
    shared_user.status = :pending
    shared_user.generate_magic_link_token

    if shared_user.save
      SharedUserMailer.access_link(shared_user).deliver_now
      flash[:notice] = '共有リンクを送信しました。'
      redirect_to edit_shared_list_path(shared_list)
    else
      flash[:alert] = '追加に失敗しました。'
      redirect_to edit_shared_list_path(shared_list)
    end
  end

  private

  def shared_user_params
    params.require(:shared_user).permit(:email, :named_by_host_user, :shared_list_id)
  end
end
