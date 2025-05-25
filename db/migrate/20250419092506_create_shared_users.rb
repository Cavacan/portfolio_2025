# frozen_string_literal: true

class CreateSharedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_users do |t|
      t.references :host_user, null: false, foreign_key: { to_table: :users }
      t.references :shared_list, null: false, foreign_key: true
      t.string :email
      t.string :initial_password_digest
      t.integer :status, null: false
      t.string :named_by_shared_user
      t.string :named_by_host_user
      t.string :magic_link_token, null: false
      t.datetime :magic_link_token_end_time, null: false
      t.string :old_magic_link_token
      t.datetime :old_magic_link_token_end_time

      t.timestamps
    end
  end
end
