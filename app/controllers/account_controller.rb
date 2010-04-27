class AccountController < ApplicationController
  unloadable
  
  def add_openid
    if using_open_id?
      authenticate_with_open_id(params[:openid_url]) do |result, identity_url|
        if result.successful?
          id = OpenIdIdentity.find_by_identity_url(identity_url)
          if id.nil?
            id = OpenIdIdentity.new :person => logged_in_person, :identity_url => identity_url
          else
            if id.person.nil?
              id.person = logged_in_person
            elsif id.person != logged_in_person
              flash[:error_messages] = ["That OpenID belongs to a different person (#{id.person.name})."]
              return
            end
          end
          if not id.save
            flash[:error_messages] = id.errors.collect { |e| e[0].humanize + " " + e[1] }
          end
        else
          flash[:error_messages] = [result.message]
        end
        redirect_to :action => 'edit_profile'
      end
    else
      flash[:error_messages] = ["Please enter an OpenID url."]
    end
  end
end
