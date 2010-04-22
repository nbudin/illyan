ENV["RAILS_ENV"] = "test"
require File.join(File.dirname(__FILE__), 'rails_app', 'config', 'environment')

require 'test_help'
require 'webrat'
require 'shoulda'
require 'factory_girl'
 
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each {|f| require f}
 
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = 'test.com'
 
require File.join(File.dirname(__FILE__), 'test_database')
 
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end
 
class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
end
