class AuthenticatedSessionsController < ApplicationController
  def new
    @authenticated_session = AuthenticatedSession.new
  end

  def create
    @authenticated_session = AuthenticatedSession.new(params[:authenticated_session])
    if @authenticated_session.save
      redirect_to account_url
    else
      render :action => :new
    end
  end

  def destroy
    current_authenticated_session.destroy
    redirect_to new_authenticated_session_url
  end
end