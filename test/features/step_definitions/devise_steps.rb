Then /^I should be signed in as "([^\"]*)"$/ do |name|
  assert controller.current_person
  assert_equal name, controller.current_person.name
end

Then /^I sign in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  When "I am on the login page"
  And "I fill in \"Email address\" with \"#{email}\""
  And "I fill in \"Password\" with \"#{password}\""
  And "I press \"Log in\""
end

Given /^I am signed in as the Joe User account$/ do
  Given "the Joe User account"
  And "I sign in as \"joe@user.com\" with password \"password\""
  Then "I should be signed in as \"Joe User\""
end 

Then /^I should not be signed in$/ do
  assert_nil controller.current_person
end

Then /^"([^\"]*)" should receive a confirmation email$/ do |email|
  assert msg = ActionMailer::Base.deliveries.first
  assert_equal msg.to[0], email
  assert_match /#{email}/, msg.body
  assert msg.body.include?(path_to "the confirmation path for \"#{email}\"")
end