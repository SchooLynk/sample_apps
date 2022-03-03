class Notification < ApplicationRecord
  MINUTES = 5.freeze # 直近の通知をまとめる間隔

  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :category, presence: true
  validates :is_read, inclusion: [true, false]

  enum category: { first_login: 0, followed: 1 }

  def self.generate_title(category, notifications)
    case category
    when Notification.categories[:followed]
      "#{notifications.first.user.followers.last.name}さん他#{notifications.count}名にフォローされました"
    end
  end
end
