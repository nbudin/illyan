Then /^I should be signed in as "([^\"]*)"$/ do |name|
  step "I should see \"My Profile\" within \"nav.application\""
end

Then /^I sign in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  step "I am on the login page"
  step "I fill in \"Email address\" with \"#{email}\""
  step "I fill in \"Password\" with \"#{password}\""
  step "I press \"Log in\""
end

Given /^I am signed in as the Joe User account$/ do
  step "the Joe User account"
  step "I sign in as \"joe@user.com\" with password \"password\""
  step "I should be signed in as \"Joe User\""
end 

Then /^I should not be signed in$/ do
  step "I should see \"Log In\" within \"nav.application\""
end

Then /^"([^\"]*)" should receive a confirmation email$/ do |email|
  assert msg = ActionMailer::Base.deliveries.first
  assert_equal msg.to[0], email
  assert_match /#{email}/, msg.body.to_s
  assert msg.body.to_s.include?(path_to "the confirmation path for \"#{email}\"")
end
