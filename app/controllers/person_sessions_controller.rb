class PersonSessionsController < ApplicationController
  unloadable
  
  def new
    @person_session = PersonSession.new
    @login = Login.new
  end

  def create
    @person_session = PersonSession.new(params[:person_session])
    if @person_session.save
      redirect_to account_url
    else
      render :action => :new
    end
  end

  def destroy
    current_person_session.destroy
    redirect_to new_person_session_url
  end
end