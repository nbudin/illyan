class CasController < ApplicationController
  def login
    response.headers.merge! 'Pragma' => 'no-cache',
      'Cache-Control' => 'no-store',
      'Expires' => (Time.now - 5.years).rfc2822

    if castronaut_response.redirect?
      return redirect_to castronaut_response.location
    end
    
    service = params['service']
    current_login_service = Service.service_for_url(service)
    session[:login_service] = current_login_service.try(:id)
    
    unless person_signed_in?
      session[:person_return_to] = request.url
      return redirect_to(new_person_session_path)
    end
    
    client_host = request.remote_ip
    
    # if we haven't redirected yet, we must already be logged into Devise
    ticket_granting_ticket = Castronaut::Models::TicketGrantingTicket.generate_for(current_person.email, client_host)
    response.set_cookie 'tgt', ticket_granting_ticket.to_cookie
    
    if !service.blank?
      service_ticket = Castronaut::Models::ServiceTicket.generate_ticket_for(service, client_host, ticket_granting_ticket)
      if service_ticket && service_ticket.service_uri
        
        # If this person hasn't logged into this service before, add it to their services list
        if current_login_service && !current_person.services.include?(current_login_service)
          current_person.services << current_login_service
          current_person.save
        end
        
        return redirect_to service_ticket.service_uri, :status => 303
      else
        flash[:alert] = "The target service your browser supplied appears to be invalid. Please contact your system administrator for help."
      end
    end
    
    redirect_to root_path
  end
  
  def logout
    sign_out(:person)
    passthrough_response!
  end
  
  def serviceValidate
    passthrough_response!
  end
  
  def proxyValidate
    if params[:ticket]
      st = Castronaut::Models::ServiceTicket.find_by_ticket(params[:ticket])
      if st && st.username
        person = Person.find_by_email(st.username)
        if person
          env["castronaut.extra_attributes"] = {
            :firstname => person.firstname,
            :lastname => person.lastname,
            :email => person.email,
            :gender => person.gender,
            :birthdate => person.birthdate.try(:rfc2822)
          }
        end
      end
    end
    
    passthrough_response!
  end
  
  private
  def castronaut_response
    @castronaut_response ||= begin
      cas_request = Rack::Request.new(env)
      request.path_info = request.path_info.sub(/^\/cas/, '')
      status, headers, body = Illyan::Application.castronaut.call(cas_request.env)
      
      Rack::Response.new(body, status, headers)
    end
  end
  
  def render_response!(resp)
    resp.headers.each do |k, v|
      response.headers[k] = v
    end      
    render :text => resp.body, :status => resp.status
  end
  
  def passthrough_response!
    render_response!(castronaut_response)
  end
end
