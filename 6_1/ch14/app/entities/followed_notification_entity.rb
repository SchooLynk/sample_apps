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
    User.find(@follower_user_ids.first).name + "さん他#{@follower_user_ids.count - 1}名にフォローされました"
  end
end
