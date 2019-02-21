require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

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

  test "index including pagination" do
    log_in_as(@michael)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    #User.page(1).each do |user|
    #  assert_select 'a[href=?]', user_path(user), text: user.name
    #end
  end
  
  test "index as non-admin" do
    log_in_as(@archer)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@michael)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    #first_page_of_users = User.paginate(page: 1)
    #first_page_of_users.each do |user|
    #  assert_select 'a[href=?]', user_path(user), text: user.name
    #  unless user == @michael
    #    assert_select 'a[href=?]', user_path(user), text: 'delete'
    #  end
    #end
    assert_difference 'User.count', -1 do
      delete user_path(@archer)
    end
  end
  
end