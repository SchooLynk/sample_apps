class Notification < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :category, presence: true
  validates :is_read, inclusion: [true, false]

  enum category: { first_login: 0, followed: 1 }
end
