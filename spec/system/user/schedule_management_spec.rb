# frozen_string_literal: true

# rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations

require 'rails_helper'

RSpec.describe '一般ユーザーによる予定管理', type: :system do
  let!(:user) { create(:user, password: 'userpass', password_confirmation: 'userpass') }

  before do
    visit root_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'userpass'
    click_button 'ログイン'
  end

  it 'ログイン後に予定を新規作成し、一覧に表示される' do
    fill_in 'schedule_title', with: '新しい予定'
    fill_in 'schedule_period', with: 3
    fill_in 'schedule_next_notification', with: (Time.zone.today + 1).strftime('%Y-%m-%dT00:00')
    fill_in 'schedule_price', with: 100
    click_button '作成'

    expect(page).to have_content('予定を作成しました。')
    expect(page).to have_content('新しい予定')
  end

  it '既存の予定を編集できる' do
    schedule = create(:schedule, creator: user, title: '旧予定', notification_period: 3,
                                next_notification: Time.zone.today + 1)

    visit edit_schedule_path(schedule)
    fill_in '予定名', with: '編集済み予定'
    fill_in '周期', with: 5
    fill_in '次回予定日', with: Time.zone.today + 2
    click_button '更新'

    expect(page).to have_content('予定を変更しました。')
    expect(page).to have_content('編集済み予定')
  end

  it '予定をアーカイブ化できる' do
    schedule = create(:schedule,
                      creator: user,
                      title: '削除予定',
                      notification_period: 3,
                      next_notification: Time.zone.today + 1,
                      after_next_notification: Time.zone.today + 4)

    visit schedules_path

    within(:xpath, "//tr[td[contains(text(), '削除予定')]]") do
      click_link '削除'
    end

    click_button 'アーカイブ化する'

    expect(page).to have_content('予定をアーカイブ化しました。')

    within('.schedule-table') do
      expect(page).not_to have_content('削除予定')
    end

    within('.schedule-archived-table') do
      expect(page).to have_content('削除予定')
      expect(page).to have_content('無効')
    end

    expect(schedule.reload).not_to be_status_enabled
  end
end

# rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
