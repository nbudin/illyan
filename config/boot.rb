ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' if Rails.env.development? || Rails.env.test? # Speed up boot time by caching expensive operations.
