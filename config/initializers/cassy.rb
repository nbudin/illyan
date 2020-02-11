require 'cassy'

Cassy.config_file = File.expand_path("config/cassy.yml", Rails.root)
require 'illyan/devise_session_authenticator'
