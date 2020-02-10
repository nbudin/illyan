source 'http://rubygems.org'

ruby '2.6.2'
gem 'rails', '4.2.11.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise', '~> 4.7.1'
gem 'devise_invitable', '~> 1.7.5'
gem 'devise-encryptable'
gem 'cancancan'
gem 'dynamic_form'
gem 'rollbar'
gem 'breach-mitigation-rails'

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
gem 'postgres_ext'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'foreman'
gem 'thin'
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
  gem 'factory_girl_rails'
  gem 'minitest'
  gem 'minitest-spec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'webdrivers', require: 'webdrivers/chromedriver'
  gem 'selenium-webdriver'
end

gem 'pry-rails', :groups => [:development, :test]
