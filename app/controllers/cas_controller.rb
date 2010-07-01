class CasController < ApplicationController  
  # A couple of methods to emulate Sinatra here.  We're mostly going to be calling
  # Castronaut presenters directly, which expect certain controller methods to exist.
  def erb(template_name, options = {})
    gem_path = File.split(Gem.loaded_specs['castronaut'].loaded_from).first
    template_file = File.join(gem_path, "app/views/#{template_name}.erb")
    locals = options.delete(:locals)
    template = Tilt[:erb].new(template_file, 1, options)
    output = template.render(self, locals)
    
    puts(render :text => output)
  end
  
  def redirect(url, status=302)
    redirect_to url, :status => status
  end
  
  def login
    response.headers.merge! 'Pragma' => 'no-cache',
      'Cache-Control' => 'no-store',
      'Expires' => (Time.now - 5.years).rfc2822
    @presenter = Castronaut::Presenters::Login.new(self)
    @presenter.represent!
    return if response.redirect_url
    
    service = @presenter.service
    @current_login_service = Service.service_for_url(service)
    session[:login_service] = @current_login_service.try(:id)
    
    unless person_signed_in?
      session[:person_return_to] = request.url
      return redirect_to(new_person_session_path)
    end
    
    client_host = @presenter.client_host
    
    
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
    @presenter = Castronaut::Presenters::Logout.new(self)
    sign_out(:person)
    
    @presenter.represent!    
    if params[:destination]
      redirect_to params[:destination]
    else
      @presenter.your_mission.call
    end
  end
  
  def service_validate
    @presenter = Castronaut::Presenters::ServiceValidate.new(self)
    @presenter.represent!
    @presenter.your_mission.call
  end
  
  def proxy_validate
    @presenter = Castronaut::Presenters::ProxyValidate.new(self)
    @presenter.represent!
    
    person = Person.find_by_email(@presenter.username)
    @presenter.extra_attributes.merge!(
      :firstname => person.firstname,
      :lastname => person.lastname,
      :email => person.email
    )
    @presenter.your_mission.call
  end
end
