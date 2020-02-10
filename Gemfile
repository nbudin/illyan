source 'http://rubygems.org'

ruby '2.6.2'
gem 'rails', '5.0.7.2'

gem 'devise', '~> 4.7.1'
gem 'devise_invitable', '~> 1.7.5'
gem 'devise-encryptable'
gem 'cancancan'
gem 'dynamic_form'
gem 'rollbar'

gem 'haml'

gem 'sprockets-rails'
gem 'sprockets'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'autoprefixer-rails'

gem 'jquery-rails'

gem 'cassy', github: 'nbudin/cassy'
gem 'doorkeeper', '5.0.0.rc1'

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
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'capistrano-maintenance', '~> 1.0', require: false
end

group :test do
  gem 'factory_bot_rails'
  gem 'minitest', '5.10.3'  # TODO upgrade once we upgrade rails to 5.1+
  gem 'minitest-spec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'webdrivers', require: 'webdrivers/chromedriver'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'
end

gem 'pry-rails', :groups => [:development, :test]
