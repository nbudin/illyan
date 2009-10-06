# Include hook code here

require 'ae_users'
require 'action_controller'

ActiveRecord::Base.send(:include, AeUsers::Acts::Permissioned)
ActiveRecord::Base.send(:include, AeUsers::Acts::SharedModel)
ActionController::Base.send(:include, AeUsers::ControllerExtensions::RequirePermission)
ActionView::Helpers::FormBuilder.send(:include, AeUsers::FormBuilderExtensions)
ActionView::Helpers::InstanceTag.send(:include, AeUsers::InstanceTagExtensions)

module ActionController
  class Base
    helper :ae_users
  end
end

infl = begin
  Inflector
rescue
  ActiveSupport::Inflector
end

infl.inflections do |inflect|
  inflect.irregular "PermissionCache", "PermissionCaches"
end
