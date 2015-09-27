require 'test_helper'

class ProfileTest < ActionDispatch::IntegrationTest
  setup do
    login_as(FactoryGirl.create(:joe_user), scope: :person)
  end
  
  it "should view my profile" do
    visit edit_profile_path
    find_field('First name').value.must_equal "Joe"
    find_field('Last name').value.must_equal "User"
  end
end