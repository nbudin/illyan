class PeopleController < ApplicationController
  before_filter :get_person, :except => :index 
  
  access_control do
    allow :admin
    
    actions :show, :edit, :update do
      allow :admin, :of => :person
    end
  end

  def edit
    # don't do this yet; I need to figure out the security implications of letting people add their own
    # openID identities (i.e. you don't want to let just anyone add any random OpenID
    #@person.open_id_identities.build
  end
  
  def update
    if @person.update_attributes(params[:person])
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
