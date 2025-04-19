class SharedListsController < ApplicationController
  def index
    @shared_lists = current_user.shared_lists
  end

  def new
    @shared_list = current_user.shared_lists.new
    @user_schedules = current_user.schedules
  end

  def create
    @shared_list = current_user.shared_lists.new(shared_list_params)
    if @shared_list.save
      if params[:schedule_ids].present?
        schedules = Schedule.where(id: params[:schedule_ids])
        @shared_list.schedules << schedules
      end
      flash[:notice] = '共有リストを作成しました。'
      redirect_to shared_lists_path
    else
      @user_schedules = current_user.schedules
      flash[:alert] = '共有リストの作成に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shared_list = SharedList.find(params[:id])
    @shared_user = SharedUser.new(email: 'shared_user@example.com')
    @user_schedules = current_user.schedules.where.not(id: @shared_list.schedule_ids)
  end

  def update
    @shared_list = SharedList.find(params[:id])

    added_ids = params[:add_schedule_ids] || []
    removed_ids = params[:remove_schedule_ids] || []

    added_ids.each do |sid|
      @shared_list.schedules << Schedule.find(sid) unless @shared_list.schedule_ids.include?(sid.to_i)
    end

    removed_ids.each do |sid|
      @shared_list.schedules.destroy(Schedule.find(sid))
    end

    redirect_to edit_shared_list_path(@shared_list)
  end

  private

  def shared_list_params
    params.require(:shared_list).permit(:list_title)
  end
end
