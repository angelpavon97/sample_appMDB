require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  def setup
    if User.find_by(email: "michael@example.com") == nil
      @user = User.new(name: "Michael Example", email: "michael@example.com", password: 'password', activated: true, activated_at: Time.zone.now)
      @user.save
    end
    @michael = User.find_by(email: "michael@example.com")
  end
  
  test "account_activation" do
    @michael.activation_token = User.new_token
    mail = UserMailer.account_activation(@michael)
    assert_equal "Account activation", mail.subject
    assert_equal [@michael.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @michael.name,               mail.body.encoded
    assert_match @michael.activation_token,   mail.body.encoded
    assert_match CGI.escape(@michael.email),  mail.body.encoded
  end
end
