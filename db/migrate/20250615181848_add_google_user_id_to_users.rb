# frozen_string_literal: true

class AddGoogleUserIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :google_user_id, :string
    add_index :users, :google_user_id, unique: true
  end
end
