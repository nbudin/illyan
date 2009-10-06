module AeUsers
  module ControllerExtensions
    module RequirePermission
      def self.included(base)
        base.extend ClassMethods
      end

      def access_denied(msg=nil, options={})
        options = {
          :layout => active_layout
        }.update(options)
        msg ||= "Sorry, you don't have access to view that page."
        if logged_in?
          body = "If you feel you've been denied access in error, please contact the administrator of this web site."
          respond_to do |format|
            format.html { render options.update({:inline => "<h1>#{msg}</h1>\n\n<div id=\"login\"><p><b>#{body}</b></p></div>"}) }
            format.xml  { render :xml => { :error => msg }.to_xml, :status => :forbidden }
            format.js   { render :json => msg, :status => :forbidden }
            format.json { render :json => msg, :status => :forbidden }
          end
        else
          flash[:error_messages] = msg
          redirect_to :controller => 'auth', :action => 'login'
        end        
      end
      
      def logged_in?
        if @logged_in_person
          return @logged_in_person
        end
        if session[:person]
          begin
            @logged_in_person = Person.find(session[:person])
          rescue ActiveRecord::RecordNotFound
          end
        elsif session[:account]
          begin
            acct = Account.find(session[:account])
            session[:person] = acct.person.id
            @logged_in_person = acct.person
          rescue ActiveRecord::RecordNotFound
          end
        elsif attempt_login_from_params
          return logged_in?
        else
          return @logged_in_person
        end
      end
    
      def logged_in_person
        return logged_in?
      end
      
      def attempt_login(login)
        @account = Account.find_by_email_address(login.email)
        if not @account.nil? and not @account.active
          redirect_to :controller => 'auth', :action => :needs_activation, :account => @account, :email => login.email, :return_to => login.return_to
          return false
        elsif not @account.nil? and @account.check_password login.password
          if (not AeUsers.profile_class.nil? and not @account.person.nil? and 
            AeUsers.profile_class.find_by_person_id(@account.person.id).nil?)

            session[:provisional_person] = @account.person.id
            redirect_to :controller => 'auth', :action => :needs_profile, :return_to => login.return_to
            return false
          else
            session[:person] = @account.person.id
            return true
          end
        else
          flash[:error_messages] = ['Invalid email address or password.']
          return false
        end
      end
      
      def attempt_open_id_login(return_to)
        if return_to
          session[:return_to] = return_to
        else
          return_to = session[:return_to]
        end
        
        openid_url = params[:openid_url]
        params.delete(:openid_url)
        
        optional_fields = Person.sreg_map.keys
        if AeUsers.profile_class and AeUsers.profile_class.respond_to?('sreg_map')
          optional_fields += AeUsers.profile_class.sreg_map.keys
        end
        authenticate_with_open_id(openid_url, :optional => optional_fields) do |result, identity_url, registration|
          if result.successful?
            id = OpenIdIdentity.find_by_identity_url(identity_url)
            if not id.nil?
              @person = id.person
            end
            if id.nil? or @person.nil?
              if AeUsers.signup_allowed?
                session[:identity_url] = identity_url
                redirect_to :controller => 'auth', :action => :needs_person, :return_to => return_to, :registration => registration.data
                return false
              else
                flash[:error_messages] = ["Sorry, you are not registered with this site."]
                return false
              end
            else
              if (not AeUsers.profile_class.nil? and AeUsers.profile_class.find_by_person_id(@person.id).nil?)
                session[:provisional_person] = @person.id
                redirect_to :controller => 'auth', :action => :needs_profile, :return_to => return_to
                return false
              else
                session[:person] = @person.id
                return true
              end
            end
          else
            flash[:error_messages] = result.message
            return false
          end
        end
        return session[:person]
      end
      
      def attempt_ticket_login(secret)
        t = AuthTicket.find_ticket(secret)
        if t.nil?
          flash[:error_messages] = ["Ticket not found"]
          return false
        else
          session[:person] = t.person
          t.destroy
          return session[:person]
        end
      end
      
      def attempt_login_from_params
        return_to = request.request_uri
        if not params[:ae_email].blank? and not params[:ae_password].blank?
          login = Login.new(:email => params[:ae_email], :password => params[:ae_password], :return_to => return_to)
          attempt_login(login)
        elsif not params[:openid_url].blank?
          attempt_open_id_login(return_to)
        elsif not params[:ae_ticket].blank?
          attempt_ticket_login(params[:ae_ticket])
        end
      end
      
      def do_permission_check(obj, perm_name, fail_msg)
        attempt_login_from_params
        p = logged_in_person
        if not (p and p.permitted?(obj, perm_name))
          access_denied fail_msg
        end
      end
      
      def create_account_and_person()
        account = Account.new(:password => params[:password1])
        person = Person.new(params[:person])
        addr = EmailAddress.new :address => params[:email], :person => person, :primary => true
        person.account = account
        
        if not AeUsers.profile_class.nil?
          app_profile = AeUsers.profile_class.send(:new, :person => person)
          app_profile.attributes = params[:app_profile]
        end
            
        if request.post?
          error_fields = []
          error_messages = []
        
          if Person.find_by_email_address(params[:email])
            error_fields.push "email"
            error_messages.push "An account at that email address already exists!"
          end
        
          if params[:password1] != params[:password2]
            error_fields += ["password1", "password2"]
            error_messages.push "Passwords do not match."
          elsif params[:password1].length == 0
            error_fields += ["password1", "password2"]
            error_messages.push "You must enter a password."
          end
        
          ["firstname", "lastname", "email", "gender"].each do |field|
            if (not params[field] or params[field].length == 0) and (not params[:person][field] or params[:person][field].length == 0)
              error_fields.push field
              error_messages.push "You must enter a value for #{field}."
            end
          end
          
          if error_fields.size > 0 or error_messages.size > 0
            flash[:error_fields] = error_fields
            flash[:error_messages] = error_messages
          else
            account.save
            addr.save
            person.save
            if app_profile
              app_profile.save
            end
            
            @account = account
            @addr = addr
            @person = person
            @app_profile = app_profile
        
            begin
              ActionMailer::Base.default_url_options[:host] = request.host
              account.generate_activation
            rescue
              account.activation_key = nil
              account.active = true
              account.save
              return :no_activation
            end
          
            return :success
          end
        end
      end

      module ClassMethods
        def require_login(conditions = {})
          before_filter conditions do |controller|
            if not controller.logged_in?
              controller.attempt_login_from_params
              if not controller.logged_in?
                controller.access_denied "Sorry, but you need to be logged in to view that page."
              end
            end
          end
        end

        def require_class_permission(perm_name, conditions = {})
          delegated = false
          if conditions[:class_name]
            cn = conditions[:class_name]
            delegated = true
          elsif conditions[:class_param]
            cpn = conditions[:class_param]
          end
          before_filter conditions do |controller|
            if cn.nil? and cpn
              cn = controller.params[cpn]
              delegated = true
            end
            controller_cn = controller.class.name.gsub(/Controller$/, "").singularize
            cn ||= controller_cn
            full_perm_name = "#{perm_name}_#{cn.tableize}"
            if delegated
              msg = "Sorry, but you are not permitted to #{perm_name} #{controller_cn.tableize.humanize.downcase} in this #{cn.tableize.humanize.singularize.downcase}."
            else
              msg = "Sorry, but you are not permitted to #{perm_name} #{cn.tableize.humanize.downcase}."
            end
            controller.do_permission_check(nil, full_perm_name, msg)
          end
        end

        def require_permission(perm_name, conditions = {})
          if conditions[:class_name]
            cn = conditions[:class_name]
          end
          id_param = conditions[:id_param] || :id
          before_filter conditions do |controller|
            cn ||= controller.class.name.gsub(/Controller$/, "").singularize
            o = eval(cn).find(controller.params[id_param])
            if not o.nil?
              controller.do_permission_check(o, perm_name, "Sorry, but you are not permitted to #{perm_name} this #{cn.tableize.singularize.humanize.downcase}.")
            end
          end
        end

        def rest_edit_permissions(options = {})
          options = {
            :restrict_create => false,
          }.update(options)
          restrict_create = options[:restrict_create]
          options.delete(:restrict_create)
          require_permission("edit", { :only => [:edit, :update] }.update(options))
          if restrict_create
            require_class_permission("create", { :only => [:new, :create] }.update(options))
          end
          require_permission("destroy", { :only => [:destroy] }.update(options))
        end

        def rest_view_permissions(options = {})
          options = {
            :restrict_list => false,
          }.update(options)
          restrict_list = options[:restrict_list]
          options.delete(:restrict_list)
          if restrict_list
            require_class_permission("list", { :only => [:index] }.update(options))
          elsif options[:class_name]
            require_permission("show", { :only => [:index], :id_param => "#{options[:class_name].tableize}_id" }.update(options))
          end
          require_permission("show", { :only => [:show] }.update(options))
        end

        def rest_permissions(options = {})
          rest_view_permissions(options)
          rest_edit_permissions(options)
        end
      end
    end
  end
end