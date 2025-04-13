namespace :user_setting do
  desc "既存ユーザーに user_setting を作成する"
  task backfill: :environment do
    User.includes(:user_setting).find_each do |user|
      unless user.user_setting
        user.create_user_setting!(need_check_done: false)
        puts "Created user_setting for user #{user.id}"
      end
    end
  end
end