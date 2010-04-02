# AeUsers
require 'active_record'
require 'illyan/acts'
require 'illyan/controller_extensions'
require 'illyan/form_builder_extensions'
require 'illyan/instance_tag_extensions'
require 'rack/openid'
require 'devise'
require 'acl9'

module Illyan
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
    Warden::Strategies.add(:openid) do
      def valid?
        env[Rack::OpenID::RESPONSE] || !params["openid_identifier"].blank?
      end

      def authenticate!
        if resp = env[Rack::OpenID::RESPONSE]
          RAILS_DEFAULT_LOGGER.info "Attempting OpenID auth: #{env["rack.openid.response"].inspect}"
          case resp.status
          when :success
            u = Person.find_for_authentication(:openid_url => resp.identity_url)
            success!(u)
          when :cancel
            fail!("OpenID auth cancelled")
          when :failure
            fail!("OpenID auth failed")
          end
        else
          header_data = Rack::OpenID.build_header(:identifier => params["openid_identifier"])
          RAILS_DEFAULT_LOGGER.info header_data
          custom!([401, {
                Rack::OpenID::AUTHENTICATE_HEADER => header_data
              }, "Sign in with OpenID"])
        end
      end
    end
  end

  def self.install_rack_openid
    ActionController::Dispatcher.middleware.use Rack::Session::Cookie
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

      yield config
    end
  end
end
