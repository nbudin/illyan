class Admin::PeopleController < ApplicationController
  load_and_authorize_resource
  before_action :require_admin!

  def index
    authorize! :list, Person

    scope = if params[:q].present?
      Person.search(params[:q])
    else
      Person.order('lower(lastname)', 'lower(firstname)', 'lower(email)')
    end

    @people = scope.paginate(page: params[:page] || 1)
  end

  def new
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
    if @person.update(person_params)
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
    @person = Person.find_by(email: params[:person][:email])
    if @person.nil?
      attrs = person_params
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
  def require_admin!
    authorize! :admin, :site
  end

  def person_params
    params.require(:person).permit(:firstname, :lastname, :gender, :birthdate, :email, :password, :confirmed_at_ymdhms, :admin)
  end
end
