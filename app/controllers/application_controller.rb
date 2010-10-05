class ApplicationController < ActionController::Base
  protect_from_forgery :unless => :current_service
  layout 'application'
  
  include Xebec::ControllerSupport
  helper Xebec::NavBarHelper
  
  def current_ability
    @current_ability ||= Ability.new(current_person || current_service)
  end
  
  def profile_name
    Illyan::Application.account_name || "Profile"
  end
  helper_method :profile_name

  nav_bar :application do |nb|
    if person_signed_in?
      nb.nav_item "My #{profile_name}", profile_path
      nb.nav_item :people, admin_people_path if can? :list, Person
      nb.nav_item :services, services_path if can? :list, Service
      nb.nav_item "Log out", destroy_person_session_path
    else
      nb.nav_item "Log in", new_person_session_path
    end
  end
  
  rescue_from CanCan::AccessDenied do
    if current_person
      render 'shared/access_denied'
    elsif current_service
      render :text => "Access denied for #{current_service.name} service", :status => :forbidden
    else
      flash[:alert] = "Please log in to access that page."
      redirect_to new_person_session_path
    end
  end
  
  protected
  def current_login_service
    @current_login_service ||= session[:login_service] && Service.find(session[:login_service])
  end
  helper_method :current_login_service
  
  def cleanup_login_service!
    session[:person_return_to] = nil
    session[:login_service] = nil
  end
end
