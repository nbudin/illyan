Feature: Authentication
  In order to sign in
  As a user
  I want to be able to use the authentication UI
  
  Scenario: Normal email/password authentication
    Given the Joe User account
    And I am on the login page
    And I fill in "Email address" with "joe@user.com"
    And I fill in "Password" with "password"
    And I press "Log in"
    Then I should be signed in as "Joe User"
  
  Scenario: Bad credentials
    Given the Joe User account
    And I am on the login page
    And I fill in "Email" with "joe@user.com"
    And I fill in "Password" with "wrongpassword"
    And I press "Log in"
    Then I should not be signed in
