require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

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
    
    if User.find_by(email: "duchess@example.gov") == nil
      @archer = User.new(name: "Sterling Archer", email: "duchess@example.gov", password: 'password', activated: true, activated_at: Time.zone.now)
      @archer.save
    end
    @archer = User.find_by(email: "duchess@example.gov")
    @ants = @archer.microposts.build(content: "Lorem ipsum", created_at: 2.years.ago)
    @ants.save
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(@michael)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@ants)
    end
    assert_redirected_to root_url
  end

end