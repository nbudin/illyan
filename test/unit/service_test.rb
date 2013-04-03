require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  context "a new service" do
    setup do
      assert @service = FactoryGirl.build(:service)
    end
    
    context "having been saved" do
      setup do
        assert @service.save
      end
      
      should "have an authentication token" do
        assert !@service.authentication_token.blank?
      end
    end
  end
  
end
