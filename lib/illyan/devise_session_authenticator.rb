module Illyan
  class DeviseSessionAuthenticator < Cassy::Authenticators::Base
    def self.find_user(credentials)
      credentials[:request].env['warden'].user
    end
    
    def self.find_user_from_ticket(ticket)
      return if ticket.nil?
      key  = Cassy.config[:client_app_user_field] || Cassy.config[:username_field] || "email"
      Person.where(key => ticket.username).first
    end
    
    def self.validate(credentials)
      find_user(credentials)
    end
  end
end