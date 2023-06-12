source 'http://rubygems.org'

ruby '3.1.2'
gem 'rails', '7.0.4.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'devise', '~> 4.8.1'
gem 'devise_invitable', '~> 2.0.6'
gem 'devise-encryptable'
gem 'cancancan'
gem 'dynamic_form'
gem 'rollbar'

gem 'haml'

gem 'sprockets-rails'
gem 'sprockets'
gem 'sass-rails'
gem 'uglifier'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'autoprefixer-rails'
gem 'coffee-rails'

gem 'jquery-rails'

gem 'crypt-isaac' # for Cassy
gem 'doorkeeper', '5.6.6'

gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'pg'
gem 'pg_search'

# gem 'foreman'
gem 'puma'
gem 'ae_users_migrator'
gem 'figaro'

gem 'capistrano', '~> 3.0', require: false, group: :development

group :development do
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 2.1', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'capistrano-maintenance', '~> 1.0', require: false
  gem 'listen'
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
end

group :test do
  gem 'factory_bot_rails'
  gem 'minitest'
  gem 'minitest-spec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'webdrivers', require: 'webdrivers/chromedriver'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'
  gem 'webmock'
end

gem 'pry-rails', :groups => [:development, :test]
