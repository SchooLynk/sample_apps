class CreateUserNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_notifications do |t|
      t.references :user,            null: false, foreign_key: true
      t.references :notification,    null: false, foreign_key: true
      t.string     :option,          null: true,  limit: 255
      t.bigint     :option_id,       null: true
      t.datetime   :notification_at, null: false

      t.timestamps
    end
  end
end
