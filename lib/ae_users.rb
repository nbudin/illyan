# AeUsers
require 'active_record'
require 'ae_users/acts'
require 'ae_users/controller_extensions'
require 'ae_users/form_builder_extensions'
require 'ae_users/instance_tag_extensions'

module AeUsers
  @@environment = :users
  def self.environment
    @@environment
  end

  def self.environment=(new_environment)
    @@environment = new_environment.to_sym
  end

  begin
    @@db_name = Rails::Configuration.new.database_configuration["users"]["database"]
    def self.db_name
      @@db_name
    end
  rescue
  end
  
  @@signup_allowed = true
  def self.signup_allowed?
    @@signup_allowed
  end

  def self.disallow_signup
    @@signup_allowed = false
  end
  
  @@permissioned_classes = []
  def self.add_permissioned_class(klass)
    if not @@permissioned_classes.include?(klass.name)
      @@permissioned_classes.push(klass.name)
    end
  end
  
  def self.permissioned_classes
    return @@permissioned_classes.collect do |name|
      eval(name)
    end
  end
  
  def self.permissioned_class(name)
    if @@permissioned_classes.include?(name)
      return eval(name)
    end
  end
  
  @@js_framework = "prototype"
  def self.js_framework
    @@js_framework
  end
  
  def self.js_framework=(framework)
    @@js_framework = framework
  end

  # yeah, the following 2 functions are Incredibly Evil(tm).  I couldn't find any other way
  # to pass around an ActiveRecord class without having it be potentially overwritten on
  # association access.
  def self.profile_class
    nil
  end

  def self.profile_class=(klass)
    module_eval <<-END_FUNC
      def self.profile_class
        return #{klass.name}
      end
    END_FUNC
  end

  def self.map_openid(map)
    map.open_id_complete 'auth', :controller => "auth", :action => "login", :requirements => { :method => :get }
  end
  
  def self.cache_permissions=(value)
    RAILS_DEFAULT_LOGGER.warn("#{caller.first}: AeUsers#cache_permissions= is deprecated")
  end
  
  def self.cache_permissions?
    RAILS_DEFAULT_LOGGER.warn("#{caller.first}: AeUsers#cache_permissions? is deprecated")
    false
  end

  def self.permission_cache
    RAILS_DEFAULT_LOGGER.warn("#{caller.first}: AeUsers#permission_cache is deprecated")
    nil
  end
end
