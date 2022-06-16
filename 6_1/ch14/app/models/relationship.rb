class Relationship < ApplicationRecord
  include Notificatable

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  after_create :notify

  def notify
    x = build_notification user: followed
    x.parent = parent_notification followed, x
    x.save
  end
end
