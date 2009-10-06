module AeUsers
  module Acts
    module Permissioned
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_permissioned(options = {})
          acts_as_authorization_object :subject_class_name => 'Person'
          acts_as_authorization_object :subject_class_name => 'Group'
          
          cattr_accessor :permission_names
          self.permission_names = options[:permission_names] || [:show, :edit, :destroy]
          self.permission_names = self.permission_names.collect do |perm|
            perm.to_s
          end
          if not self.permission_names.include? "change_permissions"
            self.permission_names.push "change_permissions"
          end
          
          AeUsers.add_permissioned_class(self)

          extend AeUsers::Acts::Permissioned::SingletonMethods
          include AeUsers::Acts::Permissioned::InstanceMethods
        end
      end

      module SingletonMethods
      end

      module InstanceMethods
        def permitted?(person, permission)
          logger.warn "#{caller.first}: permitted? is deprecated; use Person#has_role? instead"
          person.has_role? permission, self
        end
        
        def people_with_role(role_name)
          accepted_roles.find_or_create_by_name(role_name).people
        end
        
        def groups_with_role(role_name)
          accepted_roles.find_or_create_by_name(role_name).groups
        end
        
        def people_with_effective_role(role_name)
          (people_with_role(role_name) +
           groups_with_role(role_name).collect { |group| group.people }.flatten
          ).uniq
        end
        
        def permitted_people(permission)
          logger.warn "#{caller.first}: permitted_people is deprecated; use people_with_effective_role instead"
          people_with_effective_role(permission)
        end

        def grant(grantees, permissions=nil)
          logger.warn "#{caller.first}: grant is deprecated; use accepts_role! instead"
          
          if not grantees.kind_of?(Array)
            grantees = [grantees]
          end

          if not permissions.kind_of?(Array)
            if permissions.nil?
              permissions = self.class.permission_names
            else
              permissions = [permissions]
            end
          end

          grantees.each do |grantee|
            accepts_role!(perm, grantee)
          end
        end

        def revoke(grantees, permissions=nil)
          logger.warn "#{caller.first}: revoke is deprecated; use accepts_no_role! instead"

          if not grantees.kind_of?(Array)
            grantees = [grantees]
          end

          if not permissions.kind_of?(Array)
            if permissions.nil?
              permissions = self.class.permission_names
            else
              permissions = [permissions]
            end
          end

          grantees.each do |grantee|
            permissions.each do |perm|
              accepts_no_role!(perm, grantee)
            end
          end
        end
      end
    end
  end
end