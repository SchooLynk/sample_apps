require "test_helper"

class UserNotificationTest < ActiveSupport::TestCase
  def setup
    @user_notification = UserNotification.new(
      user: users(:michael),
      notification: notifications(:notifications_one)
    )
  end

  test "正常" do
    assert @user_notification.valid?
  end

  test "異常 : 必須 : user_id" do
    @user_notification.user_id = nil
    assert_not @user_notification.valid?
  end

  test "異常 : 必須 : notification_id" do
    @user_notification.notification_id = nil
    assert_not @user_notification.valid?
  end

  test "異常 : 必須 : notification_id が 2 の場合は option_id は必要" do
    @user_notification.notification = notifications(:notifications_two)
    @user_notification.option_id    = nil

    @user_notification.valid?

    assert_equal @user_notification.errors.first.type, "存在しないユーザーです"
  end

  test "異常 : 型 : notification_id が 2 の場合は option_id は数字である必要がある" do
    @user_notification.notification = notifications(:notifications_three)
    @user_notification.option       = "test"

    @user_notification.valid?

    assert_equal @user_notification.errors.first.type, "数字で入力して下さい"
  end
end
