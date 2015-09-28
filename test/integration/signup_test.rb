require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest
  setup do
    visit "/"
    click_on "Log in"
    click_on "Sign up"
    
    within "form" do
      fill_in "Email", with: "myemail@example.com"
      fill_in "person[password]", with: "LetMeIn"
      fill_in "Confirm password", with: "LetMeIn"
      fill_in "First name", with: "Jonathan"
      fill_in "Last name", with: "Livingston"
      select "March", from: "person[birthdate(2i)]"
      select "22", from: "person[birthdate(3i)]"
      select "1970", from: "person[birthdate(1i)]"
      fill_in "Gender", with: "male"
      click_on "Sign up"
    end
  end
  
  it "should send a confirmation email" do
    msg = ActionMailer::Base.deliveries.last
    msg.to[0].must_equal "myemail@example.com"
    msg.body.to_s.must_match /myemail@example.com/
    msg.body.to_s.must_include person_confirmation_path
  end
  
  it "should not sign me in" do
    visit "/"
    assert has_no_content?("My Sugar Pond account")
  end
  
  it "should not let me sign in without confirming" do
    visit "/"
    click_on "Log in"
    
    within "form" do
      fill_in "Email", with: "myemail@example.com"
      fill_in "Password", with: "LetMeIn"
      click_on "Log in"
    end
    
    assert has_no_content?("My Sugar Pond account")
  end

  describe "after confirming" do
    setup do
      @person = Person.find_by(email: "myemail@example.com")
      
      raw_confirmation_token, db_confirmation_token = 
        Devise.token_generator.generate(Person, :confirmation_token)
      @person.update_attribute(:confirmation_token, db_confirmation_token)
      
      visit person_confirmation_path(confirmation_token: raw_confirmation_token)
    end
    
    it "should confirm the user" do
      assert @person.reload.confirmed?
      assert has_content?("Your email address has been successfully confirmed.")
    end
    
    it "should let me log in immediately" do
      within "form" do
        fill_in "Email", with: "myemail@example.com"
        fill_in "Password", with: "LetMeIn"
        click_on "Log in"
      end
    
      assert has_content?("My Sugar Pond account")
    end
  end
end