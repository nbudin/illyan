module AeUsers
  module Acts
    module SharedModel
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_ae_users_shared_model
          establish_connection(AeUsers.environment)
        end
      end
    end
  end
end