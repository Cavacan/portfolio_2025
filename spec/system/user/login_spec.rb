# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '通常ログイン', type: :system do
  let!(:user) { create(:user, password: 'userpass', password_confirmation: 'userpass') }

  it 'メールとパスワードでログインできる' do
    visit root_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'userpass'
    click_button 'ログイン'

    expect(page).to have_content('ログインに成功しました。')
    expect(current_path).to eq(schedules_path)
  end
end
