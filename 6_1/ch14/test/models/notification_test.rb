require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  def setup
    @notification = notifications(:notifications_one)
  end

  test "正常" do
    assert @notification.valid?
  end

  test "異常 : 必須 : body" do
    @notification.body = nil
    assert_not @notification.valid?
  end

  test "異常 : 重複エラー : body" do
    @notification      = notifications(:notifications_two)
    @notification.body = notifications(:notifications_one).body

    @notification.valid?

    assert_equal @notification.errors.first.message, "has already been taken"
  end
end
