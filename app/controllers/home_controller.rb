class HomeController < ApplicationController
  before_action :cleanup_login_service!

  def index
    @services = Service.where(:public => true).to_a

    if person_signed_in?
      @services += current_person.services
      @services.uniq!
    end

    @services.sort_by!(&:name)
  end
end
