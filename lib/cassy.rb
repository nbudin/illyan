require 'cassy/generators/views_generator'
require 'cassy/routes'

module Cassy
  extend ActiveSupport::Autoload

  autoload :CAS
  autoload :Utils

  def self.config_file
    @config_file || ENV["RUBYCAS_CONFIG_FILE"]
  end

  def self.config_file=(path)
    @config_file = path
    @config = nil
  end

  def self.root
    Pathname.new(File.dirname(__FILE__) + "../..")
  end

  def self.config
    @config ||= ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file(config_file))
  end

  class AuthenticatorError < Exception
  end
end

require 'cassy/authenticators'
