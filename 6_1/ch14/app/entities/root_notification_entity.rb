class RootNotificationEntity
  attr_accessor :first_login_notification_entities, :followed_notification_entities

  def initialize()
    @notifications = {}
  end

  def add_notification(notification)
    add_or_merge(notification)
  end

  def add_or_merge(notification)
    type = notification.class.name
    if @notifications[type] == nil
      @notifications[type] = []
      @notifications[type] << notification
      return 
    end
    if @notifications[type]&.count&.> 0
      if @notifications[type][-1].created_at > notification.created_at - 5.minutes
        @notifications[type][-1].merge!(notification)
        return
      end
    end
    @notifications[type] << notification
  end

  def get_notifications
    notifications = []
    @notifications.each do |k,v|
      notifications.push v
      notifications.flatten!
    end
    return notifications.sort_by do |notification| 
      notification.created_at
    end 
  end

end
