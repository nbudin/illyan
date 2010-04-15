require 'test/test_helper'

class RoleTest < ActiveSupport::TestCase
  subject { Factory(:role) }
  
  should_have_and_belong_to_many :people
  should_have_and_belong_to_many :groups
  should_belong_to :authorizable
  
  context "with a Person and a Group" do
    setup do
      assert @role = Factory.create(:role)
      assert @person = Factory.create(:person)
      assert @group = Factory.create(:group)
      assert @role.people << @person
      assert @role.groups << @group
    end
    
    should "show both of them" do
      assert @role.people.include?(@person)
      assert @role.groups.include?(@group)
    end
    
    should "only allow destruction when no people or groups are left" do
      assert !@role.destroy
      
      assert @role.people = []
      assert @role.people.empty?
      assert !@role.destroy
      @role.people << @person
      
      assert @role.groups = []
      assert @role.groups.empty?
      assert !@role.destroy
      @role.groups << @group
      
      assert @role.people = []
      assert @role.groups = []
      assert @role.people.empty?
      assert @role.groups.empty?
      assert @role.destroy
    end
  end
end
