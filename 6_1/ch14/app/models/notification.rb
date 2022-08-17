class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true
  validates :message_type, presence: true
  validates :is_checked, inclusion: {in: [true, false]}
  validates :user_id, presence: true

  enum message_type: [:first_login, :followed]

  def create_first_login_message
    self.message = '初回ログインありがとうございます。'
    self.message_type = :first_login
    save!
  end

  def self.create_followed_message(followed, follower)
    five_minutes_ago = Time.now - 5.minutes
    recent_notifications = Notification.
      where(user_id: followed.id).
      where(created_at: five_minutes_ago..).
      where(message_type: 'followed')

    recent_notification_count = recent_notifications.count
    if recent_notification_count == 0
      notification = followed.notifications.build
      notification.message = "#{follower.name}さんにフォローされました"
      notification.message_type = :followed
      notification.save!
    else
      notification = recent_notifications.last
      recent_followers = followed.passive_relationships.where(created_at: (Time.now-5.minutes)..)
      if recent_followers.count == 1
        notification.message = "#{recent_followers.first.follower.name}さんにフォローされました"
      else
        recent_first_follower = recent_followers.first.follower
        recent_follower_count_exclude_first_user = recent_followers.count - 1
        notification.message = "#{recent_first_follower.name}さん他#{recent_follower_count_exclude_first_user}名にフォローされました"
      end
      notification.save!
    end
  end
end
