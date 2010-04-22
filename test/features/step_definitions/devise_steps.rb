Then /^I should be signed in as "([^\"]*)"$/ do |name|
  assert controller.current_person
  assert_equal name, controller.current_person.name
end

Then /^I should not be signed in$/ do
  assert_nil controller.current_person
end

Then /^"([^\"]*)" should receive a confirmation email for "([^\"]*)"$/ do |email, name|
  assert msg = ActionMailer::Base.deliveries.first
  assert_equal msg.to[0], email
  assert_match /#{email}/, msg.body
  assert msg.body.include?(path_to "the confirmation path for \"#{name}\"")
end