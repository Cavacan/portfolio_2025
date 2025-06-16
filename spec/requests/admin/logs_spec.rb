# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Logs', type: :request do
  let!(:admin) { create(:admin_user, password: 'adminpass', password_confirmation: 'adminpass') }

  before do
    # 管理者としてログイン（セッションを再現）
    post admin_sessions_path, params: {
      email: admin.email,
      password: 'adminpass'
    }
  end

  describe 'GET /index' do
    it 'returns http success' do
      get admin_logs_path
      expect(response).to have_http_status(:success)
    end
  end
end
