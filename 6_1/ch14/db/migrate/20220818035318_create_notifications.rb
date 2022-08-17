class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string    :message, null: false
      t.integer   :message_type, default: 0, null: false
      t.boolean   :is_checked, default: false, null: false
      t.integer   :user_id, null: false
      t.datetime  :created_at, precision: 6, null: false
      t.datetime  :updated_at, precision: 6, null: false
    end
  end
end
