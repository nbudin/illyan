Feature: Profiles
  In order to view and edit my profile
  As a user
  I want to be able to use the profile editing UIs
  
  Scenario: View my profile
    Given I am signed in as the Joe User account
    And I go to the profile page for "joe@user.com"
    Then the "First name" field should contain "Joe"
    And the "Last name" field should contain "User"
    
