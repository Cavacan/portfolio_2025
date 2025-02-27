class ChangeEmailChangeTokenEndTimeToUsers < ActiveRecord::Migration[7.1]
  def up
    change_column :users, :email_change_token_end_time, :datetime
  end

  def down
    change_column :users, :email_change_token_end_time, :string
  end
end
