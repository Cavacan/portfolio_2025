# frozen_string_literal: true

class CreateSharedListsSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_lists_schedules do |t|
      t.references :shared_list, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
