class PeopleController < ApplicationController
  before_filter :get_person, :except => [:index]
  
  access_control :except => [:index] do
    allow :admin
    
    actions :show, :edit, :update do
      allow :admin, :of => :person
    end
  end
  
  def index
    unless current_person.has_role? :admin
      redirect_to edit_person_path(current_person)
    end
    
    @people = Person.all(:order => [:lastname, :firstname])
  end

  def edit
    # don't do this yet; I need to figure out the security implications of letting people add their own
    # openID identities (i.e. you don't want to let just anyone add any random OpenID
    @person.open_id_identities.build
  end
  
  def update
    @person.attributes = params[:person]
    @person.open_id_identities.each do |oid|
      if oid.new_record?
        puts "Before: #{@person.open_id_identities.inspect}"
        @person.open_id_identities.delete(oid)
        puts "After: #{@person.open_id_identities.inspect}"
        params[:open_id_identity] = {:identity_url => oid.identity_url}
        open_id_identity = warden.authenticate(:openid, :scope => :open_id_identity)
        if open_id_identity
          @person.open_id_identities << open_id_identity
        elsif warden.result == :custom
          throw :warden, :scope => :open_id_identity
        end
      end
    end
    
    if @person.save
      respond_to do |format|
        format.html { redirect_to edit_person_url(@person) }
        format.xml  { head :ok }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { render :action => :edit }
        format.xml  { render :xml => @person.errors.to_xml }
        format.json { render :json => @person.errors.to_json }
      end
    end
  end
  
  private
  def get_person
    @person = Person.find(params[:id])
  end
end
