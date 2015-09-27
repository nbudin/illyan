module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
      
    when /the login page/
      new_person_session_path
      
    when /the signup page/
      new_person_registration_path
    
    when /the confirmation path( for \"([^\"]+)\")?/
      person = Person.find_by(email: $2)

      if person
        # Generate new raw/encrypted confirmation token pair and update database.
        # This lets us visit the new "raw" path to confirm the user.
        raw_confirmation_token, db_confirmation_token = 
          Devise.token_generator.generate(Person, :confirmation_token)
        person.update_attribute(:confirmation_token, db_confirmation_token)
        person_confirmation_path(confirmation_token: raw_confirmation_token)
      else
        person_confirmation_path
      end
    
    when /the profile page/
      edit_profile_path

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
