class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :user_id, null: false
      t.integer :category, null: false
      t.string :content, null: false
      t.integer :quantity_of_same_type_by_fixed_time, default: 0

      t.timestamps
    end
  end
end
