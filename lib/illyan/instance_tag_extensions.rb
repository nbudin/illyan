module Illyan
  module InstanceTagExtensions
    DEFAULT_USERPICKER_OPTIONS = {
      "auto_complete_url_params" => {:controller => "permission", :action => "auto_complete_for_permission_grantee"}
    }
    
    def to_user_picker_tag(people, roles, options={})
      options = options.stringify_keys
      options = DEFAULT_USERPICKER_OPTIONS.merge(options)
      add_default_name_and_id(options)
      
      default = options["default"]
      shim = tag("input", :type => "text", :id => "#{options["id"]}_shim", :value => default ? default.name : "",
                 :style => "width: 15em; display: inline; float: none;")
      hidden = to_input_field_tag("hidden", options.update("value" => default ? default.id : ""))
      
      url_params = options["auto_complete_url_params"].update(:people => people, :roles => roles,
                                             :escape => false)
      RAILS_DEFAULT_LOGGER.debug url_params.collect { |k, v| "#{k}: #{v}" }.join(", ")
      
      options["auto_complete_url"] = @template_object.url_for(url_params)
      shim + hidden + user_picker_extra_content(options) + user_picker_js(options)
    end
    
    private
    def user_picker_js(options = {})
      case Illyan.js_framework
      when "prototype"
        user_picker_js_for_prototype(options)
      when "jquery"
        user_picker_js_for_jquery(options)
      end
    end
    
    def user_picker_extra_content(options = {})
      if Illyan.js_framework == "prototype"
        return @template_object.tag("div", :id => "#{options['id']}_shim_auto_complete", :class => "auto_complete")
      end
      
      return ""
    end
    
    def user_picker_js_for_prototype(options = {})
      @template_object.auto_complete_field(:select => "grantee_id", :param_name => "q",
        :after_update_element =>
        "function (el, selected) { 
            kid = el.value.split(':');
            klass = kid[0];
            id = kid[1];
            cb = function(klass, id) {
              $('#{options['id']}').value = el.value;
              #{options['clear_after'] ? "$('#{options['id']}_shim').value = '';" : "$('#{options['id']}_shim').value = selected.getAttribute('granteeName');"}
              #{options['callback']}
            };
            cb(klass, id);
          }",
        :url => options['auto_complete_url'])
    end
    
    def user_picker_js_for_jquery(options = {})
        <<-ENDRHTML
<script type="text/javascript">
jQuery(function() {
  jQuery('\##{options['id']}_shim').autocomplete('#{options['auto_complete_url']}',
      {
        formatItem: function(data, i, n, value) {
          return value;
        },
      }).bind('result', function(e, data) {
        jQuery(jq_domid).val(data[1]);
        #{options['callback']}
      }
   );
});
</script>
ENDRHTML
    end
  end
end