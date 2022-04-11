class CreateFollowedNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :followed_notifications do |t|
      t.integer :relationship_id

      t.timestamps
    end
  end
end
