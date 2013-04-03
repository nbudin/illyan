Illyan::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation        = :log
  
  # Do not compress assets
  config.assets.compress = false
 
  # Expands the lines which load the assets
  config.assets.debug = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  
  config.action_mailer.default_url_options = { :host => 'localhost:4001' }
end

Illyan::Application.site_title = "Sugar Pond Account Central"
Illyan::Application.site_logo = "account-central.png"
Illyan::Application.theme = "account-central"
Illyan::Application.account_name = "Sugar Pond account"