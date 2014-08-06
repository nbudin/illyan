source 'http://rubygems.org'

gem 'rails', '3.2.18'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise'
gem 'devise_invitable'
gem 'devise-encryptable'
gem 'cancancan'
gem 'dynamic_form'
gem 'rollbar'
gem 'breach-mitigation-rails'

gem 'haml'

gem 'sprockets-rails', '=2.0.0.backport1'
gem 'sprockets', '=2.2.2.backport2'
gem 'sass-rails', github: 'guilleiguaran/sass-rails', branch: 'backport'
gem 'coffee-rails'
gem 'uglifier'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
 
gem 'jquery-rails'

gem 'cassy', github: 'nbudin/cassy'

gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'sqlite3', :groups => [:development, :test]
gem 'mysql2'
gem 'pg'
gem 'postgres_ext'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'foreman'
gem 'thin'
gem 'ae_users_migrator'

gem 'capistrano', '~> 3.0', require: false, group: :development

group :development do
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'capistrano-maintenance', github: 'capistrano/maintenance', require: false
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'launchy'
  gem 'turn'
  gem 'database_cleaner'
end

gem 'pry-rails', :groups => [:development, :test]
