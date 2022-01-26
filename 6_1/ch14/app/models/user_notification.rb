class UserNotification < ApplicationRecord
  NOTIFICATION_ZIP_MINUTES = 5

  belongs_to :user
  belongs_to :notification

  before_save do |user_notification|
    user_notification.notification_at = Time.current if user_notification.notification_at.blank?
  end

  validates :user_id, presence: true
  validates :notification_id, presence: true

  validate :validate_option
  validate :validate_option_id

  # IDを元に文言を取得する
  def gen_notification
    case notification_id
    when Notification::BODY_FIRST_LOGIN
      notification.body
    when Notification::BODY_FOLLOWED
      followed_user = User.find(option_id)

      format(notification.body, name: followed_user.name)
    when Notification::BODY_FOLLOWED_ZIP
      followed_user = User.find(option_id)

      format(notification.body, name: followed_user.name, count: option)
    end
  end

  private

    def validate_option
      case notification_id
      when Notification::BODY_FOLLOWED_ZIP
        errors.add(:option, "数字で入力して下さい") unless option =~ /^[0-9]+$/
      end
    end

    def validate_option_id
      case notification_id
      when Notification::BODY_FOLLOWED
        followed_user = User.find_by(id: option_id)

        errors.add(:option_id, "存在しないユーザーです") if followed_user.blank?
        errors.add(:option_id, "自分自身に通知を送ろうとしています") if followed_user&.id == user_id
      end
    end
end
