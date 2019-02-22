require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    if User.find_by(email: "michael@example.com") == nil
      @user = User.new(name: "Michael Example", email: "michael@example.com", password: 'password', activated: true, activated_at: Time.zone.now)
      @user.save
    end
    @michael = User.find_by(email: "michael@example.com")
    @micropost = @michael.microposts.build(content: "Lorem ipsum", created_at: 10.minutes.ago)
    @most_recent = @michael.microposts.build(content: "Writing a short test", created_at: Time.zone.now)
    @cat_video = @michael.microposts.build(content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk", created_at: 2.hours.ago)
    @micropost.save
    @most_recent.save
    @cat_video.save
  end

  test "profile display" do
    get user_path(@michael)
    assert_template 'users/show'
    assert_select 'title', full_title(@michael.name)
    assert_select 'h1', text: @michael.name
    assert_select 'h1>img.gravatar'
    assert_match @michael.microposts.count.to_s, response.body
    #assert_select 'div.pagination' No pagination because we have only 3 microposts
    @michael.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end