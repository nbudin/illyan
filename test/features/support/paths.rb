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
    
    when /the confirmation path for "([^\"]*)"/
      firstname, lastname = $1.split(/\s+/)
      person = Person.find(:first, :conditions => {:firstname => firstname, :lastname => lastname})
      person_confirmation_path(person, :confirmation_token => person.confirmation_token)
    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
