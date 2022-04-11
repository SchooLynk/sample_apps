class AddNotificationContentIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :notification_content_id, :integer
  end
end
