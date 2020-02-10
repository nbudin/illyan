ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
if %w[development test].include?(ENV['RAILS_ENV'])
  require 'bootsnap/setup'
end
