class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true
  validates :message_type, presence: true
  validates :is_checked, inclusion: {in: [true, false]}
  validates :user_id, presence: true

  enum message_type: [:first_login, :followed]

end
