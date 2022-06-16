module Notificatable
  extend ActiveSupport::Concern

  included do
    has_one :notification, as: :notificatable

    after_destroy :remove_notificaion
  end

  def parent_notification user, notification
    user.notifications.where(notificatable_type: notification.notificatable_type, created_at: 5.minutes.ago..).order(created_at: :asc).first
  end

  def remove_notificaion
    if notification.parent || notification.children_count == 1
      notification.destroy
    else
      Notification.decrement_counter :children_count, notification.id
    end
  end
end
