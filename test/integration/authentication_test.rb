require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    FactoryGirl.create :joe_user
    visit new_person_session_path
  end
      
  it "should accept good credentials" do
    within "form" do
      fill_in "Email address", with: "joe@user.com"
      fill_in "Password", with: "password"
      click_on "Log in"
    end
    
    within "nav.navbar-default" do
      assert has_content?("My Sugar Pond account")
    end
  end
  
  it "should reject bad credentials" do
    within "form" do
      fill_in "Email address", with: "joe@user.com"
      fill_in "Password", with: "wrongpassword"
      click_on "Log in"
    end
    
    within "nav.navbar-default" do
      assert has_no_content?("My Sugar Pond account")
    end
  end
end