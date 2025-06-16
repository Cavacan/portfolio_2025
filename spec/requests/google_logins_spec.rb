# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Googleログイン', type: :system do
  let!(:user) { create(:user, google_user_id: 'google-uid-1234') }

  before do
    stub_request(:post, "https://oauth2.googleapis.com/token")
      .to_return(status: 200, body: {
        access_token: 'google_token',
        id_token: 'id_token_dummy'
      }.to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, "https://www.googleapis.com/oauth2/v2/userinfo")
      .to_return(status: 200, body: {
        id: user.google_user_id,
        email: user.email
      }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'Googleログインが成功し、トップページにリダイレクトされる' do
    # stateを含むリダイレクトURLを取得
    visit google_login_path
    state = page.current_url.match(/state=([^&]+)/)[1]

    # callbackに正しいstateを付けてアクセス
    visit google_login_callback_path(code: 'dummy_code', state: state)

    expect(page).to have_content("Googleログインに成功しました")
    expect(current_path).to eq(schedules_path)
  end
end
