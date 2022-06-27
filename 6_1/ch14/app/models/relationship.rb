class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  has_one :notice, class_name: 'RelationshipNotice', dependent: :destroy
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  # NOTE: 通知モデルの変更は少ないことが予想されるためcallbackで対応
  after_create :with_notice

  private

    def with_notice
      create_notice(read: :yet)
    end
end
