class ApplicationController < ActionController::Base
  protect_from_forgery :unless => :current_service
  layout 'application'

  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner || current_person || current_service)
  end

  def profile_name
    ENV['ILLYAN_ACCOUNT_NAME'] || "Profile"
  end
  helper_method :profile_name

  def current_resource_owner
    @current_resource_owner ||= doorkeeper_token && Person.find(doorkeeper_token.resource_owner_id)
  end

  def current_service
    @_current_service ||= begin
      service_token = ActionController::HttpAuthentication::Token.token_and_options(request).presence.try(:first)
      service_token ||= ActionController::HttpAuthentication::Basic::user_name_and_password(request).first if request.authorization.present?
      service_token ||= params[:service_token].presence
      service_token && Service.find_by(authentication_token: service_token.to_s)
    end
  end

  rescue_from CanCan::AccessDenied do
    if current_person
      render 'shared/access_denied'
    elsif current_service
      render plain: "Access denied for #{current_service.name} service", status: :forbidden
    else
      flash[:alert] = "Please log in to access that page."
      redirect_to new_person_session_path
    end
  end

  protected
  def current_login_service
    @current_login_service ||= session[:login_service_id] && Service.find(session[:login_service_id])
  end
  helper_method :current_login_service

  def cleanup_login_service!
    session[:person_return_to] = nil
    session[:login_service] = nil
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[firstname lastname birthdate gender])
  end
end
