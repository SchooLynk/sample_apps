require 'test_helper'

class CreateNewFollowerNotificationJobTest < ActiveSupport::TestCase

  def setup
    @user1 = User.create(name: "フォローしてフォローされてる人1", email: "user1@example.com",
                         password: "foobar", password_confirmation: "foobar")
    @user2 = User.create(name: "フォローしてフォローされてる人2", email: "user2@example.com",
                         password: "foobar", password_confirmation: "foobar")
    @follower_user1 = User.create(name: "Follower User1", email: "follower1@example.com",
                                  password: "foobar", password_confirmation: "foobar")
    @follower_user2 = User.create(name: "Follower User2", email: "follower2@example.com",
                                  password: "foobar", password_confirmation: "foobar")

    # user1のフォロー (一つは5分より前)
    Relationship.create(follower_id: @user2.id, followed_id: @user1.id)
    Relationship.create(follower_id: @follower_user1.id, followed_id: @user1.id)
    Relationship.create(created_at: Time.current - 301.seconds, follower_id: @follower_user2.id, followed_id: @user1.id)
    # user2のフォロー
    Relationship.create(follower_id: @user1.id, followed_id: @user2.id)
  end

  test "should create new follow notification" do
    CreateNewFollowerNotificationJob.perform_now
    assert @user1.notifications.count == 1
    assert @user2.notifications.count == 1

    notification = @user1.notifications.first
    assert notification.title == 'You gotta new follower!'
    assert notification.content.include?('フォローしてフォローされてる人2 follows you.')
    assert notification.content.include?('Follower User1 follows you.')
    assert_not notification.content.include?('Follower User2 follows you.')
  end

end
