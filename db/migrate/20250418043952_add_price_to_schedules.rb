class AddPriceToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :price, :integer
  end
end
