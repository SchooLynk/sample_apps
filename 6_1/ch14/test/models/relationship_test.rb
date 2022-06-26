require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
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

  test 'should create with notice' do
    @relationship.save
    assert @relationship.notice
  end

  test 'should destroy with notice' do
    before_count = RelationshipNotice.count
    @relationship.save
    @relationship.destroy
    assert_equal RelationshipNotice.count, before_count
  end
end
