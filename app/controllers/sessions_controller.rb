class SessionsController < Cassy::SessionsController
  before_filter :require_ticketing_service, only: [:new]
  
  def new
    if person_signed_in?
      if session[:login_service_id]
        current_person.services << Service.find(session[:login_service_id])
      end
      create
    else
      super
      
      unless response.redirect_url.present?
        session[:person_return_to] = request.url        
        session[:login_service_id] = login_service.id
        
        redirect_to new_person_session_path
      end
    end
  end
  
  def destroy
    sign_out
    super
  end
  
  def valid_services
    Service.pluck(:urls).flatten
  end
  
  # Work around cassy's weird use of after_sign_in_path_for
  def after_sign_in_path_for(resource_or_scope)
    return resource_or_scope if resource_or_scope.kind_of?(String)
    super
  end
  
  private
  def require_ticketing_service
    detect_ticketing_service(params[:service])
    
    unless @ticketing_service
      Rollbar.report_message("Unknown service for URL #{params[:service]}", 'warning')
      render text: "Unknown service for URL #{params[:service]}", status: :forbidden
    end
  end
  
  def login_service
    @login_service ||= Service.where.any(urls: @ticketing_service).first if @ticketing_service
  end
end