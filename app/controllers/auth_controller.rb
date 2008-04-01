class AuthController < ApplicationController
  def login
    @login = Login.new(params[:login])
    @login.email ||= cookies['email']
    if request.post?
      if attempt_login(@login)
      	if @login.remember
      	  cookies['email'] = @login.email
      	end 
        redirect_to @request.env["HTTP_REFERER"]
      end
    end
  end
  
  def needs_profile
    @account = Account.find params[:account]
    
    if not AeUsers.signup_allowed?
      flash[:error_messages] = ['Your account is not valid for this site.']
      redirect_to :controller => 'main', :action => 'index'
    else
      if not AeUsers.profile_class.nil?
        @app_profile = AeUsers.profile_class.send(:new, :person => @account.person)
        @app_profile.attributes = params[:app_profile]
        
        if request.post?
          if not @account.check_password params[:password]
            flash[:error_messages] = ["Invalid password."]
          else
            @app_profile.save
            login = Login.new(:email => @account.primary_email_address, :password => params[:password])
            if attempt_login(login)
              redirect_to :controller => :main, :action => :index
            end
          end
        end
      end
    end
  end
  
  def forgot
    @account = Account.find_by_email_address(params[:email])
    if not @account.nil?
      @account.generate_password
    else
      flash[:error_messages] = ["There's no account matching that email address.  Please try again, or sign up for an account."]
      redirect_to :action => :forgot_form
    end
  end
  
  def resend_activation
    @account = Account.find params[:account]
    if not @account.nil?
      @account.generate_activation params[:email]
    else
      flash[:error_messages] = ["No account found with ID '#{params[:account]}'!"]
      redirect_to :controller => :main, :action => :index
    end
  end
  
  def logout
    session[:account] = nil
    redirect_to @request.env["HTTP_REFERER"]
  end
  
  private
  def attempt_login(login)
    @account = Account.find_by_email_address(login.email)
    if not @account.nil? and not @account.active
      redirect_to :action => :needs_activation, :account => @account, :email => login.email
      return false
    elsif not @account.nil? and @account.check_password login.password
      if (not AeUsers.profile_class.nil? and not @account.person.nil? and 
        AeUsers.profile_class.find_by_person_id(@account.person.id).nil?)
        redirect_to :action => :needs_profile, :account => @account
        return false
      else
        session[:account] = @account.id
        return true
      end
    else
      flash[:error_messages] = ['Invalid email address or password.']
      return false
    end
  end
end
