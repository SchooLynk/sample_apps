class CreateFirstLoginNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :first_login_notifications do |t|
      t.integer :notification_id

      t.timestamps
    end
  end
end
