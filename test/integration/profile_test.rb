require 'test_helper'

class ProfileTest < ActionDispatch::IntegrationTest
  setup do
    login_as(FactoryBot.create(:joe_user), scope: :person)
  end

  it "should view my profile" do
    visit edit_profile_path
    assert_equal 'Joe', find_field('First name').value
    assert_equal 'User', find_field('Last name').value
  end
end
