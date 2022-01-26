class Notification < ApplicationRecord
  BODY_FIRST_LOGIN  = 1
  BODY_FOLLOWED     = 2
  BODY_FOLLOWED_ZIP = 3

  validates :body, presence: true, uniqueness: true
end
