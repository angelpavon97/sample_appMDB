require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

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

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do
    assert_equal @most_recent, Micropost.first()
  end

end
