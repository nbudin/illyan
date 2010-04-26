module Illyan
  module ControllerExtensions
    module AuthenticatedSessions
      def self.included(base)
        base.class_eval do
          filter_parameter_logging :password, :password_confirmation
        end
      end
    end
    
    module RequirePermission
      module ClassMethods
        def require_login(conditions = {})
          code = <<-EOC
            before_filter :attempt_login_from_params
            
            access_control(#{conditions.inspect}) do
              allow logged_in
            end
          EOC
          
          logger.warn "#{caller.first}: require_login is deprecated; use the following code instead:\n#{code}"
          class_eval code
        end

        def require_class_permission(perm_name, conditions = {})
          if conditions[:class_name]
            cn = conditions.delete :class_name
          elsif conditions[:class_param]
            cpn = conditions.delete :class_param
          end
          
          controller_cn = self.class.name.gsub(/Controller$/, "").singularize
          cn ||= controller_cn
          
          full_perm_name = "#{perm_name}_#{cn.tableize}"
          
          code = <<-EOC
            access_control(#{conditions.inspect}) do
              allow :superadmin
              allow #{full_perm_name.to_sym.inspect}
            end
          EOC
          
          logger.warn "#{caller.first}: require_class_permission is deprecated; use the following code instead:\n#{code}"
          class_eval code
        end

        def require_permission(perm_name, conditions = {})
          if conditions[:class_name]
            cn = conditions.delete :class_name
          end

          id_param = conditions.delete(:id_param) || :id
          cn ||= self.class.name.gsub(/Controller$/, "").singularize
          
          code = <<-EOC
            access_control(#{conditions.inspect}) do
              allow :superadmin
              allow #{perm_name.to_sym.inspect}, :for => #{cn.tableize.singularize.to_sym.inspect}
            end
          EOC
          
          logger.warn "#{caller.first}: require_permission is deprecated; use the following code instead:\n#{code}"
          class_eval code
        end

        def rest_edit_permissions(options = {})
          options = {
            :restrict_create => false,
          }.update(options)
          restrict_create = options[:restrict_create]
          options.delete(:restrict_create)
          require_permission("edit", { :only => [:edit, :update] }.update(options))
          if restrict_create
            require_class_permission("create", { :only => [:new, :create] }.update(options))
          end
          require_permission("destroy", { :only => [:destroy] }.update(options))
        end

        def rest_view_permissions(options = {})
          options = {
            :restrict_list => false,
          }.update(options)
          restrict_list = options[:restrict_list]
          options.delete(:restrict_list)
          if restrict_list
            require_class_permission("list", { :only => [:index] }.update(options))
          elsif options[:class_name]
            require_permission("show", { :only => [:index], :id_param => "#{options[:class_name].tableize}_id" }.update(options))
          end
          require_permission("show", { :only => [:show] }.update(options))
        end

        def rest_permissions(options = {})
          rest_view_permissions(options)
          rest_edit_permissions(options)
        end
      end
    end
  end
end