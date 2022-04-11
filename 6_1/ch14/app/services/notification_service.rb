class NotificationService

  def self.create_first_login_notification(user_id)
    first_login_notification = FirstLoginNotification.create()
    notification = Notification.create(
      user_id: user_id, 
      type: 'first_login',
      notification_content_id: first_login_notification.id
    )
  end

  def self.create_followed_notification(followed_id, follower_id)
    relationship = Relationship.where(follower_id: follower_id, followed_id: followed_id).first
    if relationship
      followed_notification = FollowedNotification.create(relationship_id: relationship.id)
      notification = Notification.create(
        user_id: followed_id, 
        type: 'followed',
        notification_content_id: followed_notification.id
      )
    end
  end

  def self.unwatched_notifications(user_id)
    root_notification_entity = RootNotificationEntity.new
    Notification
      .where(user_id: user_id, watched_at: nil, type: 'first_login')
      .order(created_at: "DESC").each do |notification|
        root_notification_entity.add_notification(
          FirstLoginNotificationEntity.new(notification.id, notification.created_at)
        )
    end
    Notification
      .where(user_id: user_id, watched_at: nil, type: 'followed')
      .order(created_at: "DESC").map do |notification|
        followed_notification_entity = FollowedNotificationEntity.new(
          notification.followed_notification.relationship.follower_id,
          notification.created_at
        )
        root_notification_entity.add_notification(followed_notification_entity)
    end
    root_notification_entity.get_notifications
  end

end
