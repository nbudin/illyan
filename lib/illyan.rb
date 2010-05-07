# AeUsers
require 'active_record'
require 'illyan/controller_extensions'
require 'illyan/form_builder_extensions'
require 'illyan/instance_tag_extensions'
require 'illyan/openid_strategy'
require 'rack/openid'
require 'devise'
require 'acl9'

module Illyan  
  @@signup_allowed = true
  def self.signup_allowed?
    @@signup_allowed
  end

  def self.disallow_signup
    @@signup_allowed = false
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

  def self.install_legacy_md5_strategy
    Warden::Strategies.add(:legacy_md5) do
      def valid?
        params[scope] && params[scope]["email"] && params[scope]["password"]
      end

      def authenticate!
        p = Person.find_for_authentication(:email => params[scope]["email"])

        if p.nil? or p.legacy_password_md5.blank?
          pass
        else
          if Digest::MD5.hexdigest(params[scope]["password"]) == p.legacy_password_md5
            success!(p)
          else
            pass
          end
        end
      end
    end
  end
  
  def self.install_openid_warden_strategy
    Warden::Strategies.add(:openid, Illyan::Strategies::OpenIDAuthenticatable)
  end

  def self.install_rack_openid
    ActionController::Dispatcher.middleware.use Rack::OpenID
  end

  def self.setup
    install_openid_warden_strategy
    install_legacy_md5_strategy
    install_rack_openid

    Devise.setup do |config|
      config.warden do |manager|
        manager.default_strategies.unshift :openid
        manager.default_strategies.unshift :legacy_md5
      end
      
      config.scoped_views = true

      yield config
    end

    Acl9::config.merge!(
            :default_subject_class_name => "Person",
            :default_subject_method => "current_person",
            :protect_global_roles => true
    )
  end
end
