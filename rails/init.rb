# Include hook code here

require 'ae_users'
require 'action_controller'
require 'acl9'

Acl9::config.merge!({
  :default_subject_class_name => "Person"
})

ActiveRecord::Base.send(:include, AeUsers::Acts::Permissioned)
ActiveRecord::Base.send(:include, AeUsers::Acts::SharedModel)
ActionController::Base.send(:include, AeUsers::ControllerExtensions::RequirePermission)
ActionView::Helpers::FormBuilder.send(:include, AeUsers::FormBuilderExtensions)
ActionView::Helpers::InstanceTag.send(:include, AeUsers::InstanceTagExtensions)

infl = begin
  Inflector
rescue
  ActiveSupport::Inflector
end

infl.inflections do |inflect|
  inflect.irregular "PermissionCache", "PermissionCaches"
end
