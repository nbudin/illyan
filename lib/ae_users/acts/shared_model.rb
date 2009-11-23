module AeUsers
  module Acts
    module SharedModel
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_ae_users_shared_model
          include AeUsers::Acts::SharedModel::InstanceMethods

          if AeUsers.remote_user_store?
            before_save :write_to_user_store
          end
        end
      end
      
      module InstanceMethods
        def write_to_user_store
          if AeUsers.remote_user_store?
            # TODO implement me
          end
        end
        
        def sync_from_user_store
          if AeUsers.remote_user_store?
            # TODO implement me
          end
        end
      end
    end
  end
end