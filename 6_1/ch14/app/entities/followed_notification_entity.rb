class FollowedNotificationEntity
  attr_accessor :follower_user_ids, :created_at
  def initialize(follower_user_id, created_at)
    @follower_user_ids =  [follower_user_id]
    @created_at = created_at
  end

  def merge!(followednotificationEntity)
    @follower_user_ids = @follower_user_ids + followednotificationEntity.follower_user_ids
  end
  def message
    user_names = User.where(id: @follower_user_ids).pluck(:name).join('さん')
    "#{user_names}さんにフォローされました"
  end
end
