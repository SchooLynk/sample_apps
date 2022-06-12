require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @notification = @user.notifications.build(text: "Lorem ipsum", notification_type: 'type')
  end

  test "should be valid" do
    assert @notification.valid?
  end

  test "user id should be present" do
    @notification.user_id = nil
    assert_not @notification.valid?
  end

  test "text should be present" do
    @notification.text = nil
    assert_not @notification.valid?
  end

  test "notification_type should be present" do
    @notification.notification_type = nil
    assert_not @notification.valid?
  end
  
end
