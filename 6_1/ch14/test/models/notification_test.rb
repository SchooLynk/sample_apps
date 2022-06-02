require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "すべて入力されているとき保存される" do
    notification = users(:michael).notifications.new(message: 'メッセージ', message_type: 1, is_checked: false, user_id: 1)
    assert notification.valid?
  end

  test "messageがnilのとき保存されない" do
    notification = users(:michael).notifications.new(message: nil, message_type: 1, is_checked: false, user_id: 1)
    assert_not notification.valid?
  end

  test "message_typeがnilのとき保存される" do
    notification = users(:michael).notifications.new(message: 'メッセージ', message_type: nil, is_checked: false, user_id: 1)
    assert_not notification.valid?
  end

  test "is_checkedがnilのとき保存される" do
    notification = users(:michael).notifications.new(message: 'メッセージ', message_type: 1, is_checked: nil, user_id: 1)
    assert_not notification.valid?
  end

  test "user_idがnilのとき保存される" do
    notification = Notification.new(message: 'メッセージ', message_type: 1, is_checked: false, user_id: nil)
    assert_not notification.valid?
  end
end
