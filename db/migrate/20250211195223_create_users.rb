# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false, index: { unique: true }
      t.string :email_change_token
      t.string :email_change_token_end_time
      t.string :new_email
      t.boolean :admin
      t.string :magic_link_token
      t.datetime :magic_link_token_end_time
      t.string :old_magic_link_token
      t.datetime :old_magic_link_token_end_time

      t.timestamps
    end
  end
end
