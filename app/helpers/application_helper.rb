module ApplicationHelper
  include Acl9Helpers
  
  access_control :admin? do
    allow :admin
  end
  
  def page_title
    title = "#{Illyan::Application.site_title}"
    title << " - #{@page_title}" unless @page_title.blank?
    
    return title
  end
end
