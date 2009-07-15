module AuthHelper
  def auth_stylesheet
    "<link rel=\"stylesheet\" href=\"#{url_for :controller => 'auth', :action => 'index', :format => 'css'}\" />"
  end
end
