class CreateSharedLists < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :list_title

      t.timestamps
    end
  end
end
