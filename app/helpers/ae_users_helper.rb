module AeUsersHelper
  def permission_names(item)
    if item.kind_of? ActiveRecord::Base
      return item.class.permission_names
    else
      return item.permission_names
    end
  end
  
  def full_permission_name(item, perm)
    if item.kind_of? ActiveRecord::Base
      return perm
    else
      return "#{perm}_#{item.class.name.tableize}"
    end
  end
  
  def permission_grants(item, perm)
    if item.kind_of? ActiveRecord::Base
      grants = item.permissions.select {|p| p.permission == perm }
    else
      full_perm_name = full_permission_name(item, perm)
      grants = Permission.find_all_by_permission(full_perm_name)
    end
    return grants
  end
  
  def all_permitted?(item, perm)
    if item
      # try to short-circuit this with an eager load check
      if item.permissions.select {|p| (p.permission == perm or p.permission.nil?) and p.role.nil? and p.person.nil? }.size > 0
        return true
      end
    end
    sql = "permission = ? and (role_id = 0 or role_id is null) and (person_id = 0 or person_id is null)"
    return Permission.find(:all, :conditions => [sql, full_permission_name(item, perm)]).length > 0
  end
  
  def logged_in?
    return controller.logged_in?
  end
  
  def logged_in_person
    return controller.logged_in_person
  end
  
  def app_profile(person = nil)
    if person.nil?
      person = logged_in_person
    end

    AeUsers.profile_class.find_by_person_id(person.id)
  end
  
  def person_field(object_name, method, options={})
    it = ActionView::Base::InstanceTag.new(object_name, method, self, options.delete(:object))
    it.to_user_picker_tag(true, false, options)
  end

  def user_picker(field_name, options = {})
    options = {
      :people => true,
      :roles => false,
      :callback => nil,
      :default => nil,
      :clear_after => true
    }.update(options)
    
    domid = field_name.gsub(/\W/, "_").gsub(/__+/, "_").sub(/_$/, "").sub(/^_/, "")
    
    default = options[:default]
    rhtml = text_field_tag("#{field_name}_shim", default ? default.name : "", { :style => "width: 15em; display: inline; float: none;" })
    rhtml << hidden_field_tag(field_name, default ? default.id : "")
    auto_complete_url = url_for(:controller => "permission", :action => "auto_complete_for_permission_grantee",
                                :people => options[:people], :roles => options[:roles], :escape => false)
    
    if AeUsers.js_framework == "prototype"
      rhtml << <<-ENDRHTML
<div id="#{domid}_shim_auto_complete" class="auto_complete"></div>
<%= auto_complete_field('#{domid}_shim', :select => "grantee_id", :param_name => "q",
  :after_update_element => "function (el, selected) { 
      kid = el.value.split(':');
      klass = kid[0];
      id = kid[1];
      cb = function(klass, id) {
        $('#{domid}').value = el.value;
        #{options[:clear_after] ? "$('#{domid}_shim').value = '';" : "$('#{domid}_shim').value = selected.getAttribute('granteeName');"}
        #{options[:callback]}
      };
      cb(klass, id);
    }",
  :url => "#{auto_complete_url}") %>
ENDRHTML
    elsif AeUsers.js_framework == "jquery"
      rhtml << <<-ENDRHTML
<script type="text/javascript">
jQuery(function() {
jq_domid = "\##{domid.gsub(/(\W)/, '\\\\\\\\\1')}";
jQuery(jq_domid + "_shim").autocomplete('#{auto_complete_url}',
    {
      formatItem: function(data, i, n, value) {
        return value;
      },
    }).bind('result', function(e, data) {
      jQuery(jq_domid).val(data[1]);
      #{options[:callback]}
    }
 );
});
</script>
ENDRHTML
    end
    
    render :inline => rhtml
  end
end