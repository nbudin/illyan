require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  subject { Factory(:person) }
  
  should validate_uniqueness_of(:email)
  
  context "a person" do
    setup do
      assert @person = Factory.build(:person)
      assert @email = @person.email
    end

    context "with a birthdate" do
      setup do
        @person.birthdate = DateTime.now - 5.days
      end
      
      should "report its age correctly" do
        assert_equal 0, @person.current_age
        assert_equal 1, @person.age_as_of(DateTime.now + 1.year)
      end
    end
    
    context "having been saved" do
      setup do
        assert @person.save
      end
      
      should "come up correctly in find_for_authentication calls" do
        assert @found = Person.find_for_authentication(:email => @email)
        assert_equal @person, @found
      end
    end
  end
  
  context "a person with a legacy md5 password" do
    setup do
      @person = Factory.build(:legacy_person)
      assert_equal Digest::MD5.hexdigest("password"), @person.legacy_password_md5
    end
    
    should "convert to a Devise password correctly" do
      @person.password = "password"
      
      assert_nil @person.legacy_password_md5
      assert_not_equal Digest::MD5.hexdigest("password"), @person.encrypted_password
      assert !@person.password_salt.blank?
    end
    
    should "delete the legacy password correctly" do
      @person.delete_legacy_password!
      assert_nil @person.legacy_password_md5
    end
  end
end
