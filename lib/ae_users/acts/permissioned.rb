module AeUsers
  module Acts
    module Permissioned
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_permissioned(options = {})
          acts_as_authorization_object
          
          has_many :permissions, :as => :permissioned, :dependent => :destroy, :include => [:person, :role, :permissioned]

          cattr_accessor :permission_names
          self.permission_names = options[:permission_names] || [:show, :edit, :destroy]
          self.permission_names = self.permission_names.collect do |perm|
            perm.to_s
          end
          if not self.permission_names.include? "change_permissions"
            self.permission_names.push "change_permissions"
          end

          self.permission_names.each do |perm|
            define_method("permit_#{perm}?") do |person|
              self.permitted?(person, perm)
            end
          end
          
          AeUsers.add_permissioned_class(self)

          extend AeUsers::Acts::Permissioned::SingletonMethods
          include AeUsers::Acts::Permissioned::InstanceMethods
        end
      end

      module SingletonMethods
      end

      module InstanceMethods
        def permitted?(person, permission=nil)
          person.permitted? self, permission
        end
        
        def permitted_people(permission)
          grants = permissions.select { |perm| perm.permission == permission }
          people = []
          grants.collect {|grant| grant.grantee}.each do |grantee|
            if grantee.kind_of? Person
              if not people.include? grantee
                people << grantee
              end
            elsif grantee.kind_of? Role
              grantee.people.each do |person|
                if not people.include? person
                  people << person
                end
              end
            end
          end
          return people
        end

        def grant(grantees, permissions=nil)
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
            if grantee.kind_of? Role
              permissions.each do |perm|
                if AeUsers.cache_permissions?
                  grantee.members.each do |person|
                    AeUsers.permission_cache.invalidate(person, self, perm)
                  end
                end
                Permission.create :role => grantee, :permission => perm, :permissioned => self
              end
            elsif grantee.kind_of? Person
              permissions.each do |perm|
                if AeUsers.cache_permissions?
                  AeUsers.permission_cache.invalidate(grantee, self, perm)
                end
                Permission.create :person => grantee, :permission => perm, :permissioned => self
              end
            end
          end
        end

        def revoke(grantees, permissions=nil)
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
              existing = if grantee.kind_of? Role
                if AeUsers.cache_permissions?
                  grantee.members.each do |person|
                    AeUsers.permission_cache.invalidate(person, self, perm)
                  end
                end
                Permission.find_by_role_and_permission_type(grantee, perm)
              elsif grantee.kind_of? Person
                if AeUsers.cache_permissions?
                  AeUsers.permission_cache.invalidate(pesron, self, perm)
                end
                Permission.find_by_person_and_permission_type(person, perm)
              end

              if existing
                existing.destroy
              end
            end
          end
        end
      end
    end
  end
end