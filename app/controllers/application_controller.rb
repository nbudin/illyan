class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  include Xebec::ControllerSupport
  helper Xebec::NavBarHelper
  
  def current_ability
    @current_ability ||= Ability.new(current_person)
  end

  nav_bar :application do |nb|
    if current_person
      nb.nav_item current_person.name, profile_path
      if can? :edit, Person
        nb.nav_item :people, admin_people_path
        nb.nav_item :services, services_path
      end
      nb.nav_item "Log out", destroy_person_session_path
    else
      nb.nav_item "Log in", new_person_session_path
    end
  end
  
  rescue_from CanCan::AccessDenied do
    if current_person
      render 'shared/access_denied'
    else
      flash[:alert] = "Please log in to access that page."
      redirect_to new_person_session_path
    end
  end
end
