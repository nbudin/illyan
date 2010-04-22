Then /^I should be signed in as "([^\"]*)"$/ do |name|
  assert controller.current_person
  assert_equal name, controller.current_person.name
end

Then /^I should not be signed in$/ do
  assert_nil controller.current_person
end