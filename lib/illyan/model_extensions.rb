module Illyan
  module ModelExtensions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods      
      def illyan_authorization_object(options = {})
        if options.has_key?(:subject_class_name)
          acts_as_authorization_object(options)
        else
          acts_as_authorization_object(options.merge(:subject_class_name => 'Person'))
          acts_as_authorization_object(options.merge(:subject_class_name => 'Group'))
        end

        include Illyan::ModelExtensions::InstanceMethods
      end
    end

    module InstanceMethods     
      def people_with_role(role_name, options={})
        people = accepted_roles.find_or_create_by_name(role_name).people
        
        unless options[:ignore_groups]
          people += groups_with_role(role_name).collect { |group| group.people }.flatten
          people.uniq! 
        end
        
        return people
      end
      
      def groups_with_role(role_name)
        accepted_roles.find_or_create_by_name(role_name).groups
      end
    end
  end
end