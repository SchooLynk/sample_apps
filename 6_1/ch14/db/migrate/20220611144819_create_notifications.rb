class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.string :text, null: false

      t.timestamps
    end
    add_index :notifications, :notification_type
  end
end
