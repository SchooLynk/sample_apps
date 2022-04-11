class FollowedNotification < ApplicationRecord
  has_one :notification, ->(self_obj) { where(notification_content_id: self_obj.id) }
  has_one :relationship,  foreign_key: "id", primary_key: "relationship_id"
end
