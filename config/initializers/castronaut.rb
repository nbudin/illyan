require 'castronaut'
require 'castronaut/rails_configuration'

Castronaut.config = Castronaut::RailsConfiguration.new
Castronaut.config.organization_name = Illyan::Application.site_title