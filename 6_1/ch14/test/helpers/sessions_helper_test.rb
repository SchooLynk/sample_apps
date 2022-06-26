require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test 'should increment login_count if login_count == 1 create FirstLoginNotice' do
    log_in @user
    assert_equal 1, @user.login_count
    assert @user.first_login_notice
    log_out
    log_in @user
    assert_equal 2, @user.login_count
    assert_equal 1, FirstLoginNotice.count
  end
end