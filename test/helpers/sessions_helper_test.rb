require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    if User.find_by(email: "michael@example.com") == nil
      @user = User.new(name: "Michael Example", email: "michael@example.com", password: 'password')
      @user.save
    end
    @michael = User.find_by(email: "michael@example.com")
    remember(@michael)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @michael, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @michael.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end