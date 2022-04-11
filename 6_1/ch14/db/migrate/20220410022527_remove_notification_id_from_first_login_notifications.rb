class RemoveNotificationIdFromFirstLoginNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_column :first_login_notifications, :notification_id, :integer
  end
end
