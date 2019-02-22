require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    if User.find_by(email: "michael@example.com") == nil
      @user = User.new(name: "Michael Example", email: "michael@example.com", password: 'password', activated: true, activated_at: Time.zone.now)
      @user.save
    end
    @michael = User.find_by(email: "michael@example.com")
  end
  
  test "unsuccessful edit" do
    log_in_as(@michael)
    get edit_user_path(@michael)
    assert_template 'users/edit'
    patch user_path(@michael), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
  
  
  test "successful edit" do
    log_in_as(@michael)
    get edit_user_path(@michael)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@michael), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
  #  assert_not flash.empty?
  #  assert_redirected_to @michael
  #  @michael.reload
  #  assert_equal name,  @michael.name
  #  assert_equal email, @michael.email
  end
  
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@michael)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@michael), params: { user: { name: @michael.name,
                                              email: @michael.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "successful edit with friendly forwarding" do
    
    get edit_user_path(@michael)
    log_in_as(@michael)
    assert_redirected_to edit_user_url(@michael)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@michael), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    #assert_redirected_to @michael
    #@michael.reload
    #assert_equal name,  @michael.name
    #assert_equal email, @michael.email
  end
  
end
