require 'test/test_helper'

class AuthorizationObjectTest < ActiveSupport::TestCase
  subject { Factory(:post) }
  
  should_have_many :accepted_roles
  
  context "A new post" do
    setup do
      assert @post = Factory.create(:post)
    end
    
    should "not have any authorized people or groups" do
      assert_equal 0, @post.people.count
      assert_equal 0, @post.groups.count
    end
  end
end