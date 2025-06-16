# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'LINEログイン', type: :system do
  let!(:user) { create(:user, line_user_id: 'U1234567890abcdef') }

  before do
    stub_request(:post, "https://api.line.me/oauth2/v2.1/token")
      .to_return(status: 200, body: {
        access_token: 'dummy_token',
        id_token: 'dummy_id_token'
      }.to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, "https://api.line.me/v2/profile")
      .to_return(status: 200, body: {
        userId: user.line_user_id,
        displayName: "Test User"
      }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'LINEログインが成功し、トップページにリダイレクトされる' do
    visit line_login_path
    state = page.current_url.match(/state=([^&]+)/)[1]

    visit line_login_callback_path(code: 'dummy_code', state: state)
    expect(page).to have_content("LINEログインに成功しました")
    expect(current_path).to eq(schedules_path)
  end
end
