require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #include Mongoid::Document
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end
end