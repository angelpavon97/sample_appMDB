require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    if User.find_by(email: "michael@example.com") != nil
      @user = User.find_by(email: "michael@example.com")
      @user.destroy
      @user = User.new(name: "Michael Example", email: "michael@example.com", password: 'password', admin: true, activated: true, activated_at: Time.zone.now)
      @user.save
    end
    @michael = User.find_by(email: "michael@example.com")
    
    if User.find_by(email: "duchess@example.gov") == nil
      @archer = User.new(name: "Sterling Archer", email: "duchess@example.gov", password: 'password', activated: true, activated_at: Time.zone.now)
      @archer.save
    end
    @archer = User.find_by(email: "duchess@example.gov")
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end


  test "should redirect edit when logged in as wrong user" do
    log_in_as(@archer)
    get edit_user_path(@michael)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@archer)
    patch user_path(@michael), params: { user: { name: @michael.name,
                                              email: @michael.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@michael)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@archer)
    assert_no_difference 'User.count' do
      delete user_path(@michael)
    end
    assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    get following_user_path(@michael)
    #assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@michael)
    #assert_redirected_to login_url
  end
end
