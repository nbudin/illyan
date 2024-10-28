source "http://rubygems.org"

ruby File.read(File.expand_path("../.ruby-version", __FILE__)).strip
gem "rails", "7.2.1.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

gem "aws-sdk-rails"
gem "devise", "~> 4.9"
gem "devise_invitable", "~> 2.0.9"
gem "devise-encryptable"
gem "cancancan"
gem "dynamic_form"
gem "rollbar"

gem "haml"

gem "sprockets-rails"
gem "sprockets"
gem "sass-rails"
gem "uglifier"
gem "bootstrap-sass", "~> 3.4.1"
gem "autoprefixer-rails"
gem "coffee-rails"

gem "jquery-rails"

gem "doorkeeper"

gem "will_paginate"
gem "will_paginate-bootstrap"
gem "pg"
gem "pg_search"

gem "puma"
gem "figaro"

group :development do
  gem "listen"
  gem "ed25519"
  gem "bcrypt_pbkdf"
end

group :test do
  gem "factory_bot_rails"
  gem "minitest"
  gem "minitest-spec-rails"
  gem "minitest-reporters"
  gem "capybara"
  gem "launchy"
  gem "database_cleaner"
  gem "webdrivers", require: "webdrivers/chromedriver"
  gem "selenium-webdriver"
  gem "rails-controller-testing"
  gem "webmock"
end

gem "pry-rails", groups: %i[development test]
