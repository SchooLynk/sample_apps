class NoticesFormatter
  class << self
    def call(user:)
      new(user: user).call  
    end
  end

  def initialize(user:)
    @user = user
  end

  def call
    notices = []
    notices << first_login_notice
    notices << follow_notices
    notices_already_read
    notices.flatten.compact
  end

  private

    attr_reader :user

    def first_login_notice
      record = user.first_login_notice
      return nil if record.nil? || record.already?

      '初回ログインありがとうございます。'
    end

    def follow_notices
      grouped_notice_records.map do |_, records|
        name = records.first.relationship.follower.name
        name + (records.size == 1 ? 'さんにフォローされました' : "さん他#{records.size - 1}名にフォローされました") 
      end
    end

    def relationship_notices
      @relationship_notices ||= RelationshipNotice.eager_load(relationship: :follower)
                                                  .where(id: user.passive_relationships.ids, read: :yet)
    end

    def grouped_notice_records
      relationship_notices.group_by do |record|
        str = record.created_at.strftime('%Y%m%d%H%M')
        add_str = str.last.to_i > 4 ? '5' : '0'
        str.chop << add_str 
      end
    end

    # ここで通知のreadを更新
    def notices_already_read; end
end
