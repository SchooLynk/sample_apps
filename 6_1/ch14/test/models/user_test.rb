require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael  = users(:michael)
    archer   = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

  test "should have notification when user is activated" do
    @user.save

    assert @user.notifications.blank?
    assert_not @user.activated

    @user.activate

    assert @user.activated
    assert_equal @user.notifications.first.content,  '初回ログインありがとうございます。'
    assert_equal @user.notifications.first.category,  'first_login'
  end

  test "should have notification when followed user" do
    archer   = users(:archer)

    michael  = users(:michael)
    travel_to Time.new(2022, 11, 11, 01, 01, 44) do
      michael.follow(archer)

      assert_equal archer.notifications.last.content,  "#{michael.name}さんにフォローされました。"
      assert_equal archer.notifications.last.category,  'followed'
      assert_equal archer.notifications.count,  1
    end

    # 5分以内に同じ種類の通知が発生する場合は一つの通知にまとめられる
    lana    = users(:lana)
    travel_to Time.new(2022, 11, 11, 01, 03, 44) do
      lana.follow(archer)

      assert_equal archer.notifications.last.content,  "#{lana.name}さん他1名にフォローされました。"
      assert_equal archer.notifications.last.category,  'followed'
      assert_equal archer.notifications.count,  1
    end

    # 5分以内に同じ種類の通知が発生する場合は一つの通知にまとめられる
    malory    = users(:malory)
    travel_to Time.new(2022, 11, 11, 01, 05, 44) do
      malory.follow(archer)

      assert_equal archer.notifications.last.content,  "#{malory.name}さん他2名にフォローされました。"
      assert_equal archer.notifications.last.category,  'followed'
      assert_equal archer.notifications.count,  1
    end

    # 5分以後に同じ種類の通知が発生する場合は一つの通知にまとめられない
    user_1    = users(:user_1)
    travel_to Time.new(2022, 11, 11, 01, 11, 44) do
      user_1.follow(archer)

      assert_equal archer.notifications.last.content,  "#{user_1.name}さんにフォローされました。"
      assert_equal archer.notifications.last.category,  'followed'
      assert_equal archer.notifications.count,  2
    end
  end
end
