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
    elsif recent_notification_count == 1
      recent_first_follower_name = recent_notifications.first.message.split('さん')[0]
      cut_sentence = recent_notifications.first.message.split('さん他')
      followed_count = cut_sentence.size == 1 ? 0 :  cut_sentence[1][0]&.to_i
      recent_notifications.first.update(message: "#{recent_first_follower_name}さん他#{followed_count + 1}名にフォローされました")
      recent_notifications.first.save!
    end
  end
end
