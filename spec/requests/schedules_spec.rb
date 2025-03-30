require 'rails_helper'

RSpec.describe "Schedules", type: :request do
  let(:user) { create(:user, password: 'password') }

  before do
    post login_path, params: { email: user.email, password: 'password' }
  end

  describe 'POST /schedules' do
    context '正しいパラメータの場合' do
      it '予定を作成できる' do
        expect {
          post schedules_path, params: {
            schedule: {
              title: 'Rspec test',
              notification_period: 7,
              next_notification: Date.tomorrow
            }
          }
        }.to change(Schedule, :count).by(1)
  
        expect(response).to redirect_to(schedules_path)
        follow_redirect!
        expect(response.body).to include('予定を作成しました。')
        expect(response.body).to include('Rspec test')
      end
    end

    context '不正なパラメータの場合' do
      it '予定作成に失敗、エラーを表示する。' do
        post schedules_path, params: {
          schedule: {
            title: "",
            notification_period: "",
            next_notification: ""
          }
        }
    
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('入力されていない項目があります')
      end
    end
  end

  describe 'PATCH /schedules/:id' do
    let!(:schedule) { create(:schedule, creator: user) }

    context '更新成功' do
      it '予定を変更できる。' do
        patch schedule_path(schedule), params: {
          schedule: {
            title: "編集済み予定",
            notification_period: 7,
            next_notification: Date.today + 2.days
          }
        }

        expect(response).to redirect_to(schedules_path)
        follow_redirect!
        expect(response.body).to include("予定を変更しました。")
      end
    end

    context "更新に失敗する場合" do
      it "エラーが表示される" do
        patch schedule_path(schedule), params: {
          schedule: {
            title: "",
            notification_period: "",
            next_notification: ""
          }
        }

        expect(response.body).to include("編集に失敗しました。")
      end
    end
  end

  describe "PATCH /schedules/:id/archive_complete" do
    let!(:schedule) {
      create(:schedule,
            creator: user,
            title: "アーカイブ予定",
            notification_period: 7,
            next_notification: Date.today + 2.days
      )
    }
    it "予定をアーカイブ化できる" do
      patch archive_complete_schedule_path(schedule)

      expect(response).to redirect_to(schedules_path)
      follow_redirect!
      expect(response.body).to include("予定をアーカイブ化しました。")
      expect(schedule.reload.status).to eq("disabled")
    end
  end
end        
