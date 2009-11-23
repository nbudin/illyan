# AeUsers
require 'active_record'
require 'ae_users/acts'
require 'ae_users/controller_extensions'
require 'ae_users/form_builder_extensions'
require 'ae_users/instance_tag_extensions'

module AeUsers
  @@user_store_base_url = nil
  def self.user_store_base_url
    @@user_store_base_url
  end
  
  def self.remote_user_store?
    !(@@user_store_base_url.nil?)
  end
  
  def self.user_store_base_url=(url)
    @@user_store_base_url = url
  end
  
  @@signup_allowed = true
  def self.signup_allowed?
    @@signup_allowed
  end

  def self.disallow_signup
    @@signup_allowed = false
  end
  
  @@authorization_object_classes = Set.new
  def self.add_authorization_object_class(klass)
    @@authorization_object_classes.add(klass.name)
  end
  
  def self.authorization_object_classes
    return @@authorization_object_classes.collect do |name|
      eval(name)
    end
  end
  
  def self.authorization_object_class(name)
    if @@authorization_object_classes.include?(name)
      return eval(name)
    end
  end
  
  def self.add_permissioned_class(klass)
    RAILS_DEFAULT_LOGGER.warn "#{caller.first}: AeUsers.add_permissioned_class is deprectated; use add_authorization_object_class instead"
    add_authorization_object_class(klass)
  end
  
  def self.permissioned_classes
    RAILS_DEFAULT_LOGGER.warn "#{caller.first}: AeUsers.permissioned_classes is deprectated; use authorization_object_classes instead"
    authorization_object_classes
  end
  
  def self.permissioned_class(name)
    RAILS_DEFAULT_LOGGER.warn "#{caller.first}: AeUsers.permissioned_class is deprectated; use authorization_object_class instead"
    authorization_object_class(name)
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
