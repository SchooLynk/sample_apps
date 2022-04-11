class FirstLoginNotificationEntity < NotificationEntity
  attr_accessor :ids, :created_at
  def initialize(id, created_at)
    @ids = [id]
    @created_at = created_at
  end
  def message
    '会員登録成功しました'
  end
end
