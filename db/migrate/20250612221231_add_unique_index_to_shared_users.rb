# frozen_string_literal: true

class AddUniqueIndexToSharedUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :shared_users, %i[email shared_list_id], unique: true
  end
end
