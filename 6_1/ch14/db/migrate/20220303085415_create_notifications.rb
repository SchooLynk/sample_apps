class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :title, null: false
      t.integer :category, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.boolean :is_read, null: false, default: false
      
      t.timestamps
    end
  end
end
