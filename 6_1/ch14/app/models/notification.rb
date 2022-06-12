class Notification < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :notification_type, presence: true
  validates :text, presence: true

  scope :follow, -> { where(notification_type: 'follow') }

  # 更新日時フォーマット
  def time
    self.updated_at.strftime('%Y/%m/%d %H:%M')
  end 
end
