Feature: Signup
  In order to sign up for an account
  As a user
  I want to be able to use the registration and confirmation UIs
  
  Scenario: New user registration
    Given I am on the home page
    And I follow "Log in"
    And I follow "Sign up"
    
    Then I should be on the signup page
    When I fill in "Email" with "myemail@example.com"
    And I fill in "person[password]" with "LetMeIn"
    And I fill in "Confirm password" with "LetMeIn"
    And I fill in "First name" with "Jonathan"
    And I fill in "Last name" with "Livingston"
    And I select "March" from "person[birthdate(2i)]"
    And I select "22" from "person[birthdate(3i)]"
    And I select "1970" from "person[birthdate(1i)]"
    And I fill in "Gender" with "male"
    And I press "Sign up"
    Then "myemail@example.com" should receive a confirmation email
    And I should not be signed in
    
    When I go to the home page
    Then I should not be signed in
    
    When I follow "Log in"
    And I fill in "Email address" with "myemail@example.com"
    And I fill in "Password" with "LetMeIn"
    And I press "Log in"
    Then I should not be signed in
    
    When I go to the confirmation path for "myemail@example.com"
    Then I should be signed in as "Jonathan Livingston"
