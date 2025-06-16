# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SharedLists', type: :request do
  let!(:user) { create(:user, password: 'userpass', password_confirmation: 'userpass') }

  before do
    post login_path, params: { email: user.email, password: 'userpass' }
  end

  describe 'POST /shared_lists' do
    it 'creates a shared list' do
      post shared_lists_path, params: {
        shared_list: { list_title: 'テストリスト' }
      }

      expect(response).to redirect_to(shared_lists_path)
      expect(SharedList.last.list_title).to eq('テストリスト')
      expect(SharedList.last.user_id).to eq(user.id) 
    end
  end
end
