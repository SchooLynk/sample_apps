class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :type
      t.datetime :watched_at

      t.timestamps
    end
  end
end
