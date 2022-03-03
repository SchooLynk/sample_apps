require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  def setup
    @notification = Notification.new(
      user_id: users(:michael).id,
      title: 'Your are followed!',
      category: Notification.categories[:followed],
      is_read: false
    )
  end

  test "should be valid" do
    assert @notification.valid?
  end

  test "should require a user_id" do
    @notification.user_id = nil
    assert_not @notification.valid?
  end

  test "should require a title" do
    @notification.title = nil
    assert_not @notification.valid?
  end

  test "should require a category" do
    @notification.category = nil
    assert_not @notification.valid?
  end
end
