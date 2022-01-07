require 'test_helper'

class CreateWelcomeNotificationJobTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should create welocme notification" do
    CreateWelcomeNotificationJob.perform_now(@user)
    assert @user.notifications.count == 1
    notification = @user.notifications.first
    assert notification.title == "Welcome Example User!"
  end

end
