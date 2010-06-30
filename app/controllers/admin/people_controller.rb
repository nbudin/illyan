class Admin::PeopleController < ApplicationController
  load_and_authorize_resource
    
  def index
    authorize! :list, Person
    @people = Person.all(:order => [:lastname, :firstname])
  end
  
  def new
    @person = Person.new(params[:person])
  end
  
  def show
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
    @person = Person.new(params[:person])
    set_protected_attributes!
    @person.password = (0..8).map{ ('a'..'z').to_a[rand(26)] }.join
    
    if @person.save
      @person.send_reset_password_instructions
      respond_to do |format|
        format.html { redirect_to admin_person_url(@person) }
        format.xml  { head :ok }
        format.json { head :ok }
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
    %w{confirmed_at_ymdhms admin}.each do |attr|
      @person.send("#{attr}=", params[:person][attr])
    end
  end
end
