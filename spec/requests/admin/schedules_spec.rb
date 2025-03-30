require 'rails_helper'

RSpec.describe "Admin::Schedules", type: :request do
  let(:admin) { create(:admin_user) }
  let(:user) { create(:user) }
  let!(:schedule) {
    create(:schedule,
           creator: user,
           title: "ユーザー予定",
           notification_period: 5,
           next_notification: Date.tomorrow)
  }

  before do
    allow(UserMailer).to receive_message_chain(:send_schedule_change_notification, :deliver_now)
    post admin_login_path, params: { email: admin.email, password: 'adminpass' }
  end

  describe "管理者ログイン" do
    before do
      User.create!(
        email: "admin@example.com",
        password: "admin",
        password_confirmation: "admin",
        admin: true
      )
    end

    it "ログイン成功メッセージが表示されること" do
      post '/admin/sessions',  # ← ここを修正！
           params: { email: "admin@example.com", password: "admin" },
           headers: { "Accept" => "text/html" }

      expect(response.body).to include("ログインしました。")
    end
  end

  describe "管理者による予定の変更" do
    it "ユーザーの予定を編集できる" do
      patch schedule_path(schedule), params: {
        schedule: {
          title: "管理者編集予定",
          notification_period: 3,
          next_notification: Date.today + 1.day
        }
      }

      expect(response).to redirect_to(schedules_path)
      expect(schedule.reload.title).to eq("管理者編集予定")
    end
  end

  describe "管理者による予定のアーカイブ化" do
    it "ユーザーの予定をアーカイブ化できる" do
      patch archive_complete_schedule_path(schedule)

      expect(response).to redirect_to(schedules_path)
      expect(schedule.reload.status).to eq("disabled")
    end
  end
end