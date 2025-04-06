class AddTokenToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :done_token, :string
  end
end
