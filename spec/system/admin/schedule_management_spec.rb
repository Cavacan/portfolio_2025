require 'rails_helper'

RSpec.describe '管理者による予定管理', type: :system do
  let!(:admin) { create(:admin_user, password: 'adminpass', password_confirmation: 'adminpass') }
  let!(:user) { create(:user) }
  let!(:schedule) do
    create(:schedule, creator: user, title: 'テスト予定', notification_period: 3, next_notification: Date.tomorrow)
  end

  before do
    visit admin_login_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: 'adminpass'
    click_button 'ログイン'
  end

  it 'ログイン後に予定を編集できる' do
    visit edit_schedule_path(schedule)
    fill_in '予定名', with: '管理者による編集'
    fill_in '周期', with: 5
    fill_in '次回予定日', with: Date.today + 3.days
    click_button '更新'

    expect(page).to have_content('予定を変更しました。')
    expect(page).to have_content('管理者による編集')
  end

  it 'ログイン後に予定をアーカイブ化できる' do
    visit admin_dashboard_path

    # 一覧テーブルから特定タイトルの行を探し「削除」リンクをクリック
    within(:xpath, "//tr[td[contains(text(), 'テスト予定')]]") do
      click_link '削除'
    end

    # アーカイブ確認画面でボタンを押す
    click_button 'アーカイブ化する'

    # 結果を検証
    expect(page).to have_content('予定をアーカイブ化しました。')
    expect(current_path).to eq(admin_dashboard_path)

    # モデルの状態も確認
    expect(schedule.reload.status_enabled?).to be_falsey
  end
end
