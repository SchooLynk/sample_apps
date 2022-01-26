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

  test ".create_user_notification! : 正常 : 初回ログイン" do
    michael = users(:michael)

    michael.create_user_notification!(Notification::BODY_FIRST_LOGIN)

    # 通知が格納されている
    assert_includes michael.user_notifications.map(&:gen_notification), "初回ログインありがとうございます。"

    assert_difference "UserNotification.count", -1 do
      michael.user_notifications.destroy_all
    end
  end

  test ".create_user_notification! : 正常 : フォロー" do
    michael = users(:michael)
    archer  = users(:archer)

    # archer をフォローする
    archer.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: michael.id })

    # archer に対して通知が格納されている
    assert_includes archer.user_notifications.map(&:gen_notification), "Michael Exampleさんにフォローされました"

    assert_difference "UserNotification.count", 0 do
      michael.user_notifications.destroy_all
    end
  end

  test ".create_user_notification! : 異常 : フォロー : 存在しないユーザー" do
    michael = users(:michael)

    # 存在しないユーザーからの通知なのでエラー
    e = assert_raises ActiveRecord::RecordInvalid do
      michael.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: 0 })
    end

    assert_equal "Validation failed: Option 存在しないユーザーです", e.message
  end

  test ".create_user_notification! : 異常 : フォロー : 自分自身をフォロー" do
    michael = users(:michael)

    # 自分自身にフォローされた通知は送れないのでエラー
    e = assert_raises ActiveRecord::RecordInvalid do
      michael.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: michael.id })
    end

    assert_equal "Validation failed: Option 自分自身に通知を送ろうとしています", e.message
  end

  test ".create_user_notification! : 正常 : 違うユーザーに5分以内にもう一度フォローされる" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)

    # lana と archer が michael をフォローされた場合の通知
    michael.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: archer.id })
    michael.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: lana.id })

    # michaelに対して通知が格納されている
    assert_includes michael.user_notifications.map(&:gen_notification), "Sterling Archerさん他1名にフォローされました"

    assert_difference "UserNotification.count", -1 do
      michael.user_notifications.destroy_all
    end
  end

  test ".create_user_notification! : 正常 : 通知が混ざっている" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    malory  = users(:malory)

    # ログイン
    michael.create_user_notification!(Notification::BODY_FIRST_LOGIN)
    # archer が michael をフォロー
    michael.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: archer.id })

    # 時間をすすめる
    # TODO: マイクロ秒の指定ができないため 1秒 プラスして対応しています
    travel_to(UserNotification::NOTIFICATION_ZIP_MINUTES.minutes.since + 1)

    # lana と malory が michael をフォロー
    michael.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: lana.id })
    michael.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: malory.id })

    assert_equal(
      michael.user_notifications.map(&:gen_notification),
      [
        "初回ログインありがとうございます。",
        "Sterling Archerさんにフォローされました",
        "Lana Kaneさん他1名にフォローされました"
      ]
    )

    assert_difference "UserNotification.count", -3 do
      michael.user_notifications.destroy_all
    end
  end
end
