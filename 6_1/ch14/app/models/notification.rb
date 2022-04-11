class Notification < ApplicationRecord
  self.inheritance_column = :_type_disabled
  validate :first_login_notification_unique_validation
  belongs_to :first_login_notification, primary_key: "id", foreign_key: "notification_content_id", optional: true
  belongs_to :followed_notification, primary_key: "id", foreign_key: "notification_content_id", optional: true

  def first_login_notification_unique_validation
    if type == 'first_login'
      if Notification.where(type: 'first_login', user_id: user_id).count > 0
        errors.add(:type, "already announced")
      end
    end
    true
  end

end
