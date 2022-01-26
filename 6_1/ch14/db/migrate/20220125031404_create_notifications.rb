class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :body, null: false, limit: 255

      t.timestamps
    end
    add_index :notifications, :body, unique: true
  end
end
