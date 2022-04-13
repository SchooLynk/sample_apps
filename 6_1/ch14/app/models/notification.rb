class Notification < ApplicationRecord
  attr_accessor :from_user_name

  FIRST_LOGIN_NOTIFICATION_CONTENT = '初回ログインありがとうございます。'
  FIXED_TIME = 5

  belongs_to :user

  enum category: { first_login: 0, followed: 1 }

  validates :user_id, presence: true
  validates :category, presence: true

  before_save :init_and_reduce_followed_notification, if: :followed?

  def init_and_reduce_followed_notification
    unless same_type_notification_within_fixed_time?
      self.content = "#{self.from_user_name}さんにフォローされました。"

      return
    end

    self.content = "#{self.from_user_name}さん他#{last_same_category_notification.quantity_of_same_type_by_fixed_time + 1}名にフォローされました。"
    self.quantity_of_same_type_by_fixed_time = last_same_category_notification.quantity_of_same_type_by_fixed_time + 1

    last_same_category_notification.destroy!
  end

  private

  def same_type_notification_within_fixed_time?
    return false unless last_same_category_notification

    last_same_category_notification.created_at + FIXED_TIME.minutes > Time.now
  end

  def last_same_category_notification
    user.notifications.where(category: category).last
  end
end
