class Admin::PeopleController < ApplicationController
  load_and_authorize_resource
    
  def index
    authorize! :list, Person
    @people = Person.paginate(:page => params[:page], :order => "lower(lastname), lower(firstname), lower(email)")
  end
  
  def new
    @person = Person.new(params[:person])
  end
  
  def show
    respond_to do |format|
      format.html {}
      format.xml  { render :xml => @person.to_xml }
      format.json { render :json => @person.to_json }
    end
  end
  
  def edit
  end
  
  def edit_account
  end
  
  def change_password
  end
  
  def update
    @person.attributes = params[:person]
    set_protected_attributes!
    
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
        format.html { redirect_to admin_person_url(@person) }
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
  
  def create
    @person = Person.find_by_email(params[:person][:email])
    if @person.nil?
      attrs = params[:person]
      attrs[:confirmed_at] = Time.now
      attrs[:services] = [current_service] if current_service
      @person = Person.invite!(attrs)
    elsif current_service
      @person.services << current_service unless @person.services.include?(current_service)
    end
    
    if @person.save
      respond_to do |format|
        format.html { redirect_to admin_person_url(@person) }
        format.xml  { render :xml => @person.to_xml }
        format.json { render :json => @person.to_json }
      end
    else
      respond_to do |format|
        format.html { render :action => :new }
        format.xml  { render :xml => @person.errors.to_xml }
        format.json { render :json => @person.errors.to_json }
      end
    end
  end
  
  private
  def get_person
    @person = Person.find(params[:id])
  end
  
  def set_protected_attributes!
    %w{admin confirmed_at_ymdhms}.each do |attr|
      @person.send("#{attr}=", params[:person][attr])
    end
  end
end
