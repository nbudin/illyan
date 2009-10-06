# Include hook code here

require 'ae_users'

ActiveRecord::Base.send(:include, AeUsers::Acts::Permissioned)
ActiveRecord::Base.send(:include, AeUsers::Acts::SharedModel)
ActionController::Base.send(:include, AeUsers::ControllerExtensions::RequirePermission)
ActionView::Base.send(:include, AeUsers::HelperFunctions)
ActionView::Base.send(:include, AeUsers::FormHelperFunctions)
ActionView::Helpers::FormBuilder.send(:include, AeUsers::FormBuilderFunctions)
ActionView::Helpers::InstanceTag.send(:include, AeUsers::InstanceTagExtensions)

infl = begin
  Inflector
rescue
  ActiveSupport::Inflector
end

infl.inflections do |inflect|
  inflect.irregular "PermissionCache", "PermissionCaches"
end
