require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

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

  test "micropost interface" do
    log_in_as(@michael)
    get root_path
    #assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    #assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @michael.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete links)
    get user_path(@archer)
    assert_select 'a', text: 'delete', count: 0
  end
end