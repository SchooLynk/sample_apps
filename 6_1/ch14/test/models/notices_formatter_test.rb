require "test_helper"

class NoticesFormatterTest < ActiveSupport::TestCase

  def setup
    @user = users(:login_count_one)
  end

  test 'noting notices' do
    result = NoticesFormatter.call(user: @user)
    assert_equal [], result
  end

  test 'only first_login_notice' do
    @user.create_first_login_notice(read: :yet)
    
    result = NoticesFormatter.call(user: @user)
    assert_equal %w[初回ログインありがとうございます。], result
  end

  test 'one follow_notice' do
    other_user = users(:user_1)
    other_user.follow(@user)

    result = NoticesFormatter.call(user: @user)
    assert_equal ["#{other_user.name}さんにフォローされました"], result
  end

  test 'two follow_notice' do
    # setup
    other_user1 = users(:user_1)
    other_user1.follow(@user)
    RelationshipNotice.last.update(created_at: 6.minutes.from_now)
    other_user2 = users(:user_2)
    other_user2.follow(@user)

    result = NoticesFormatter.call(user: @user)
    assert_equal ["#{other_user1.name}さんにフォローされました", "#{other_user2.name}さんにフォローされました"], result
  end

  test 'two follow_notice in 5min' do
    # setup
    other_user1 = users(:user_1)
    other_user1.follow(@user)
    other_user2 = users(:user_2)
    other_user2.follow(@user)

    result = NoticesFormatter.call(user: @user)
    assert_equal ["#{other_user1.name}さん他1名にフォローされました"], result
  end

  test 'many notices' do
    # setup
    @user.create_first_login_notice(read: :yet)

    other_user1 = users(:user_1)
    other_user1.follow(@user)
    RelationshipNotice.last.update(created_at: Time.zone.parse('2022-06-01 10:00:00'))
    other_user2 = users(:user_2)
    other_user2.follow(@user)
    RelationshipNotice.last.update(created_at: Time.zone.parse('2022-06-01 10:04:00'))
    other_user3 = users(:user_3)
    other_user3.follow(@user)
    RelationshipNotice.last.update(created_at: Time.zone.parse('2022-06-01 10:05:00'))
    other_user4 = users(:user_4)
    other_user4.follow(@user)
    RelationshipNotice.last.update(created_at: Time.zone.parse('2022-06-01 10:11:00'))

    result = NoticesFormatter.call(user: @user)
    assert_equal ["初回ログインありがとうございます。",
                  "#{other_user1.name}さん他1名にフォローされました",
                  "#{other_user3.name}さんにフォローされました",
                  "#{other_user4.name}さんにフォローされました"], result
  end
end
