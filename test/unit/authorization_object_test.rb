require 'test/test_helper'

class AuthorizationObjectTest < ActiveSupport::TestCase
  subject { Factory(:person) }
  
  should_have_many :accepted_roles
  
  context "A new person" do
    setup do
      assert @person = Factory.create(:person)
    end
    
    should "not have any authorized people or groups" do
      assert_equal 0, @person.people.count
      assert_equal 0, @person.groups.count
    end
  end
end