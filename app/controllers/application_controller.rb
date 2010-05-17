class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  include Xebec::ControllerSupport
  helper Xebec::NavBarHelper

  nav_bar :application do |nb|
    if current_person
      nb.nav_item current_person.name, edit_person_path(current_person)
      if current_person.has_role?(:admin)
        nb.nav_item :people
      end
      nb.nav_item "Log out", destroy_person_session_path
    else
      nb.nav_item "Log in", new_person_session_path
    end
  end
end
