source 'http://rubygems.org'

gem 'rails', '3.0.0.beta3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'warden', '0.10.3'
gem 'devise', '1.1.rc1'
gem 'devise_openid_authenticatable', '1.0.0.alpha1'
gem 'acl9', :git => 'http://github.com/be9/acl9.git' # just until Oleg releases the join table name fix
gem 'rack-openid', :require => 'rack/openid'
gem 'xebec', :git => 'http://github.com/jamesarosen/xebec.git'

gem 'sinatra'
gem 'ruby-net-ldap'
gem 'fast_xs'
gem 'castronaut', :git => "http://github.com/nbudin/castronaut.git"

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for certain environments:
# gem 'rspec', :group => :test
group :test do
  gem 'factory_girl', :git => "git://github.com/thoughtbot/factory_girl.git",
    :branch => "rails3"
  gem 'shoulda', :git => "git://github.com/thoughtbot/shoulda.git",
    :branch => "rails3", :require => nil
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'launchy'
end
