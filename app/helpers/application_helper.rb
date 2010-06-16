module ApplicationHelper
  #include Acl9Helpers
  
  #access_control :admin? do
  #  allow :admin
  #end
  
  def page_title
    title = "#{Illyan::Application.site_title}"
    title << " - #{@page_title}" unless @page_title.blank?
    
    return title
  end
  
  def site_banner
    link_to root_url do
      if Illyan::Application.site_logo
        image_tag(Illyan::Application.site_logo, :alt => Illyan::Application.site_title)
      else
        Illyan::Application.site_title
      end
    end
  end
  
  def theme_stylesheet_link_tag
    if Illyan::Application.theme
      stylesheet_link_tag Illyan::Application.theme
    end
  end
end
