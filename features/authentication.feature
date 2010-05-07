Feature: Authentication
  In order to sign in
  As a user
  I want to be able to use the authentication UI
  
  Scenario: Normal email/password authentication
    Given the Joe User account
    And I sign in as "joe@user.com" with password "password"
    Then I should be signed in as "Joe User"
  
  Scenario: Bad credentials
    Given the Joe User account
    And I sign in as "joe@user.com" with password "wrongpassword"
    Then I should not be signed in
