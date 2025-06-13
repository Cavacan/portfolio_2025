# frozen_string_literal: true

class SharedListsController < ApplicationController
  def index
    @shared_lists = current_user.shared_lists
  end

  def new
    @shared_list = current_user.shared_lists.new
    @user_schedules = current_user.schedules
  end

  def edit
    @shared_list = SharedList.find(params[:id])
    @shared_user = SharedUser.new(email: 'shared_user@example.com')
    @user_schedules = current_user.schedules.where.not(id: @shared_list.schedule_ids)
  end

  def create
    @shared_list = current_user.shared_lists.new(shared_list_params)
    if @shared_list.save
      attach_schedules_to(@shared_list)
      flash[:notice] = '共有リストを作成しました。'
      redirect_to shared_lists_path
    else
      @user_schedules = current_user.schedules
      flash[:alert] = '共有リストの作成に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @shared_list = SharedList.find(params[:id])

    add_schedules(@shared_list, params[:add_schedule_ids])
    remove_schedules(@shared_list, params[:remove_schedule_ids])

    redirect_to edit_shared_list_path(@shared_list)
  end

  def pdf
    shared_list = current_user.shared_lists.find(params[:id])
    pdf = SharedListsPdf.new(shared_list.schedules.order(:next_notification), shared_list.list_title)

    send_data pdf.render,
              filename: "shared_list-#{shared_list.list_title}_#{Time.current.strftime('%Y%m%d')}.pdf",
              type: 'application/pdf',
              disposition: 'attachment'
  end

  private

  def shared_list_params
    params.require(:shared_list).permit(:list_title)
  end

  def attach_schedules_to(shared_list)
    return if params[:schedule_ids].blank?

    schedules = Schedule.where(id: params[:schedule_ids])
    shared_list.schedules << schedules
  end

  def add_schedules(shared_list, ids)
    Array(ids).each do |sid|
      sid_int = sid.to_i
      shared_list.schedules << Schedule.find(sid_int) unless shared_list.schedule_ids.include?(sid_int)
    end
  end

  def remove_schedules(shared_list, ids)
    Array(ids).each do |sid|
      shared_list.schedules.destroy(Schedule.find(sid))
    end
  end
end
