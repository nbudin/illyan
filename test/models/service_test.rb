require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  describe "a new service" do
    setup do
      assert @service = FactoryBot.build(:service)
    end

    describe "having been saved" do
      setup do
        assert @service.save
      end

      it "should have an authentication token" do
        assert !@service.authentication_token.blank?
      end

      it "should have an oauth_application with only the https URIs" do
        assert @service.oauth_application
        assert_equal 'https://google.com', @service.oauth_application.redirect_uri
      end
    end
  end

end
