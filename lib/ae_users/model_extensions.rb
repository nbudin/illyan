module AeUsers
  module ModelExtensions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_permissioned(options = {})
        logger.warn "#{caller.first}: acts_as_permissioned is deprecated; use acts_as_ae_users_authorization_object instead"
        acts_as_ae_users_authorization_object(options)
      end
      
      def acts_as_ae_users_authorization_object(options = {})
        if options.has_key?(:subject_class_name)
          acts_as_authorization_object(options)
        else
          acts_as_authorization_object(options.merge(:subject_class_name => 'Person'))
          acts_as_authorization_object(options.merge(:subject_class_name => 'Group'))
        end
        
        cattr_accessor :role_names
        if options[:permission_names]
          logger.warn "#{caller.first}: calling acts_as_ae_users_authorization_object with :permission_names option is deprecated; use :role_names instead"
          options[:role_names] ||= Set.new
          options[:role_names].merge(options[:permission_names])
        end
        self.role_names = Set.new(options[:role_names] || [:show, :edit, :destroy])
        self.role_names = Set.new(self.role_names.collect(&:to_s))
        if not self.role_names.include? "change_permissions"
          self.role_names.add "change_permissions"
        end
        
        AeUsers.add_authorization_object_class(self)

        extend AeUsers::ModelExtensions::SingletonMethods
        include AeUsers::ModelExtensions::InstanceMethods
      end
    end

    module SingletonMethods
      def permission_names
        logger.warn "#{caller.first}: permission_names is deprecated; use role_names instead"
        role_names
      end
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