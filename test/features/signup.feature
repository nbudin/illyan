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
    And I fill in "Password" with "LetMeIn"
    And I fill in "Password confirmation" with "LetMeIn"
    And I fill in "First name" with "Jonathan"
    And I fill in "Last name" with "Livingston"
    And I select "March 22, 1970" as the "Date of birth" date
    And I select "male" from "Gender"
    And I press "Sign up"
    Then "myemail@example.com" should receive a confirmation email for "Jonathan Livingston"
    And I should be signed in as "Jonathan Livingston"
    
    When I follow "Log out"
    Then I should not be signed in
    
    When I go to the confirmation path for "Jonathan Livingston"
    Then show me the page
