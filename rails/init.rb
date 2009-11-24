require 'illyan'
require 'action_controller'
require 'acl9'

ActiveRecord::Base.send(:include, Illyan::ModelExtensions)
ActiveRecord::Base.send(:include, Illyan::Acts::SharedModel)
ActionController::Base.send(:include, Illyan::ControllerExtensions::RequirePermission)
ActionView::Helpers::FormBuilder.send(:include, Illyan::FormBuilderExtensions)
ActionView::Helpers::InstanceTag.send(:include, Illyan::InstanceTagExtensions)