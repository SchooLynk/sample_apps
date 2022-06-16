class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :notificatable, polymorphic: true, null: false
      t.belongs_to :parent, null: true, foreign_key: false
      t.integer :children_count, null: false, default: 1

      t.timestamps

      t.index [:user_id, :created_at]
    end
  end
end
