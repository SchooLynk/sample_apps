class FirstLoginNotification < ApplicationRecord
  has_one :notification, ->(self_obj) { where(notification_content_id: self_obj.id) }
end
