class HomeController < ApplicationController
  before_filter :cleanup_login_service!
  
  def index
    @services = Service.where(:public => true)
    
    if person_signed_in?
      @services += current_person.services
      @services.uniq!
    end
  end
end
