module IllyanHelper
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
  
  def authorization_subject(subject)
    html = case subject
    when Person
      image_tag("illyan/person.png", :alt => "Person")
    else
      image_tag("illyan/group.png", :alt => "Group")
    end
    html << " "
    if subject.respond_to?(:name)
      html << subject.name
    else
      html << "#{subject.class.name.humanize} #{subject.id}"
    end
    return html
  end
  
  def role_subjects_list(object, role, options = {})
    options[:editing] ||= (logged_in? and logged_in_person.has_role?("change_permissions", object))
    
    role_id_base = "role_#{role}_on_#{object.class.name}_#{object.class.id}"

    subjects = object.people_with_role(role) + object.groups_with_role(role)
    html = content_tag(:ul) do
      if subjects.length > 0
        subjects.collect do |subject|
          content_tag(:li) do
            id = "#{role_id_base}_for_#{subject.class.name}_#{subject.id}"
            content_tag(:span, :id => id) do
              subject_html = authorization_subject(subject)
              if options[:editing]
                subject_html << link_to_remote("Remove",
                  { :url => { :controller => "permission", :action => "revoke", :id => grant.id, :format => "js" },
                    :success => "$('grant_#{grant.id}').remove();",
                    :confirm => "Are you sure you want to revoke that permission?",
                    :failure => "alert(request.responseText)" },
                  { :class => "authorization_action" }
                )
              else
                subject_html
              end
            end
          end
        end.join("\n")
      else
        content_tag(:li, "Nobody")
      end
    end
    
    if options[:editing]
      subject_target_id = "#{role_id_base}_insert_subjects_here"
      show_add_subject_id = "#{role_id_base}_show_add_subject"
      html << content_tag(:div, :id => subject_target_id)
      html << link_to_function("Add", :class => "authorization_action", :id => show_add_subject_id) do |page|
        page[show_add_subject_id].hide
        page[add_subject_id].show
        # focus the userpicker shim element
      end
      
    end
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
  
  def app_profile(person = nil)
    if person.nil?
      person = logged_in_person
    end

    Illyan.profile_class.find_by_person_id(person.id)
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
    
    if Illyan.js_framework == "prototype"
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
    elsif Illyan.js_framework == "jquery"
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