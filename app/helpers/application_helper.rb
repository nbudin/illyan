module ApplicationHelper  
  def login_headline(extra_text = nil)
    headline = if current_login_service
      "Log into #{current_login_service.name}"
    else
      "Log in"
    end
    
    if extra_text
      headline << " #{extra_text}"
    end
    
    return headline
  end
  
  def login_headline_with_account
    if Illyan::Application.account_name
      login_headline "with your #{Illyan::Application.account_name}"
    else
      login_headline
    end
  end
  
  def page_title
    title = "#{Illyan::Application.site_title}"
    title << " - #{@page_title}" unless @page_title.blank?
    
    return title
  end
end
