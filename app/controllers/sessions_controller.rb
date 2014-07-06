class SessionsController < Cassy::SessionsController
  def new
    if person_signed_in?
      create
    else
      super
      
      unless response.redirect_url.present?
        session[:person_return_to] = request.url
        session[:login_service] = Service.find_by_url(@ticketing_service).id if @ticketing_service
        redirect_to new_person_session_path
      end
    end
  end
  
  def destroy
    sign_out
    super
  end
  
  def valid_services
    Service.pluck(:url)
  end
  
  # Work around cassy's weird use of after_sign_in_path_for
  def after_sign_in_path_for(resource_or_scope)
    return resource_or_scope if resource_or_scope.kind_of?(String)
    super
  end
end