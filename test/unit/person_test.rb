require 'test/test_helper'

class PersonTest < ActiveSupport::TestCase
  subject { Factory(:person) }
  
  should_have_many :open_id_identities
  should_validate_uniqueness_of :email
  should_allow_values_for :email, nil
  
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
  
  context "a person with an OpenID" do
    setup do
      assert @person = Factory.build(:openid_person)
      assert @identity_url = @person.open_id_identities.first.identity_url
    end
    
    should "find its own OpenID url correctly" do
      assert_equal @identity_url, @person.openid_url
    end
    
    context "having been saved" do
      setup do
        assert @person.save
      end
      
      should "come up correctly in find_for_authentication calls" do
        assert @found = Person.find_for_authentication(:openid_url => @identity_url)
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