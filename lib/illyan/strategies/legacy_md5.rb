module Illyan
  module Strategies
    class LegacyMD5 < Devise::Strategies::Base
      def valid?
        mapping.to.respond_to?(:legacy_password_md5) && params[scope] && 
          params[scope]["email"] && params[scope]["password"]
      end

      def authenticate!
        p = mapping.to.find_for_authentication(:email => params[scope]["email"])

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
end