require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  describe "a new service" do
    setup do
      assert @service = FactoryGirl.build(:service)
    end
    
    describe "having been saved" do
      setup do
        assert @service.save
      end
      
      it "should have an authentication token" do
        assert !@service.authentication_token.blank?
      end
    end
  end
  
end
