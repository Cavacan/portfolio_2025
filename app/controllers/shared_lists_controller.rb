class SharedListsController < ApplicationController
  def index
    @shared_lists = current_user.shared_lists
  end

  def new
    @shared_list = current_user.shared_lists.new
  end

  def create
    @shared_list = current_user.shared_lists.new(shared_list_params)
    if @shared_list.save
      flash[:notice] = '共有リストを作成しました。'
      redirect_to shared_lists_path
    else
      flash[:alert] = '共有リストの作成に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shared_list_params
    params.require(:shared_list).permit(:list_title)
  end
end
