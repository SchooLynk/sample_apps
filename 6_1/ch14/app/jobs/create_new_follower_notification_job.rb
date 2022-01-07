# Sidekiq Schedulerの様な仕組みを使って5分間隔で実行させる前提
class CreateNewFollowerNotificationJob < ActiveJob::Base

  def perform(since = Time.current - 5.minutes)
    has_new_followed_user_ids =
      Relationship.select('followed_id')
                  .where('relationships.created_at > ?', since)
                  .group(:followed_id)
                  .pluck(:followed_id)

    has_new_followed_user_ids.each do |user_id|
      user = User.find(user_id)
      new_relationships =
        user.passive_relationships
            .joins(:follower)
            .where('relationships.created_at > ?', since)

      notification = user.notifications
                         .build(title: "You gotta new follower!",
                               content: build_content(new_relationships))
      notification.save
    end
  end

  private
    def build_content(new_relationships)
      new_relationships.map { |relationship| "#{relationship.follower.name} follows you." }
                       .join("\n")
    end
end
