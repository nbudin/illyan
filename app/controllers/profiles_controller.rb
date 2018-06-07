class ProfilesController < ApplicationController
  before_filter :authenticate_person!
  before_filter :get_person
  before_filter :cleanup_login_service!

  def show
  end

  def edit
  end

  def change_password
  end

  def update
    @person.attributes = person_params

    if @person.save
      respond_to do |format|
        format.html { redirect_to profile_url }
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
    @person = current_person
  end

  def person_params
    params.require(:person).permit(:firstname, :lastname, :gender, :birthdate, :email, :password, :password_confirmation)
  end
end
