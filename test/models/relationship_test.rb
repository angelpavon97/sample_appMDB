require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    
    if User.find_by(email: "michael@example.com") == nil
      @user = User.new(name: "Michael Example", email: "michael@example.com", password: 'password', activated: true, activated_at: Time.zone.now)
      @user.save
    end
    @michael = User.find_by(email: "michael@example.com")
    
    if User.find_by(email: "duchess@example.gov") == nil
      @archer = User.new(name: "Sterling Archer", email: "duchess@example.gov", password: 'password', activated: true, activated_at: Time.zone.now)
      @archer.save
    end
    @archer = User.find_by(email: "duchess@example.gov")
    
    @relationship = Relationship.new(follower_id: @michael.id,
                                     followed_id: @archer.id)
    @relationship.save
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end