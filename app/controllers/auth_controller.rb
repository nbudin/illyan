class AuthController < ApplicationController
  unloadable
  
  def needs_person
    @open_id_identity = OpenIdIdentity.find_or_create_by_identity_url(session[:identity_url])
    @person = Person.new
    if not Illyan.profile_class.nil?
      @app_profile = Illyan.profile_class.send(:new, :person => @person)
    end
    
    if params[:registration]
      person_map = HashWithIndifferentAccess.new(Person.sreg_map)
      profile_map = if Illyan.profile_class and Illyan.profile_class.respond_to?("sreg_map")
        HashWithIndifferentAccess.new(Illyan.profile_class.sreg_map)
      else
        nil
      end
        
      params[:registration].each_pair do |key, value|
        if key == 'email'
          params[:email] = value
        elsif person_map.has_key?(key.to_s)
          mapper = person_map[key]
          attrs = mapper.call(value)
          @person.attributes = attrs
        elsif (profile_map and profile_map.has_key?(key))
          mapper = profile_map[key]
          @app_profile.attributes = mapper.call(value)
        end
      end
    end
    if params[:person]
      @person.attributes = params[:person]
    end
    if params[:app_profile] and @app_profile
      @app_profile.attributes = params[:app_profile]
    end
    
    if request.post?
      error_messages = []
      error_fields = []
      
      ["firstname", "lastname", "gender"].each do |field|
        if not @person.send(field)
          error_fields.push field
          error_messages.push "You must enter a value for #{field}."
        end
      end
      
      if not params[:email]
        error_fields.push("email")
        error_messages.push "You must enter a value for email."
      end
      
      if error_messages.length > 0
        flash[:error_fields] = error_fields
        flash[:error_messages] = error_messages
      else
        @person.save
        @person.primary_email_address = params[:email]
        @open_id_identity.person = @person
        @open_id_identity.save
        if @app_profile
          @app_profile.save
        end
        
        session[:person] = @person
        redirect_to session[:return_to]
      end
    end
  end
  
  def needs_profile
    @person = Person.find session[:provisional_person]
    if @person.nil?
      flash[:error_messages] = ["Couldn't find a person record with that ID.  
        Something may have gone wrong internally.  Please try again, and if the problem persists, please contact
        the site administrator."]
      redirect_to :back
    end
    
    if not Illyan.signup_allowed?
      flash[:error_messages] = ['Your account is not valid for this site.']
      redirect_to url_for("/")
    else
      if not Illyan.profile_class.nil?
        @app_profile = Illyan.profile_class.send(:new, :person_id => session[:provisional_person])
        @app_profile.attributes = params[:app_profile]
        
        if request.post?
          @app_profile.save
          session[:person] = @person
          redirect_to params[:return_to]
        end
      end
    end
  end
end
