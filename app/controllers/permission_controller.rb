class PermissionController < ApplicationController
  unloadable
  
  before_filter :get_authorization_subject_and_object, :only => [:grant, :revoke]
  access_control do
    deny anonymous
    allow :superadmin
    allow :change_permissions, :only => [:edit]
    allow :change_permissions, :for => :authorization_object, :only => [:grant]
    allow :change_permissions, :for => :authorization_object, :only => [:revoke],
                               :unless => :revoking_own_change_permissions_role?
  end
  
  def auto_complete_for_permission_grantee
    if params[:q]
      query = params[:q].strip.downcase
      liketerm = "%#{query}%"
      terms = query.split
      
      if params[:people] == "true"
        sql = terms.collect do |t|
          "((LOWER(firstname) like ?) OR (LOWER(lastname) like ?))"
        end.join(" AND ")
        doubleterms = []
        terms.each do |t|
          doubleterms.push("%#{t}%")
          doubleterms.push("%#{t}%")
        end
        @grantees = Person.find(:all, :conditions => ([sql] + doubleterms))
        @grantees += EmailAddress.find(:all,
                                       :conditions => ["LOWER(address) like ?", liketerm]).collect do |ea|
          ea.person
        end
      else
        @grantees = []
      end

      if params[:roles] == "true"      
        @grantees += Role.find(:all,
                               :conditions => ["LOWER(name) like ?", liketerm])
      end
      
      @grantees.uniq!
    else
      @grantees = []
    end
    
    render :partial => "add_grantee"
  end
  
  layout nil, :only => [:grant]
  def grant
    @authorization_object.has_role!(params[:role])
  end
  
  def revoke
    @authorization_object.has_no_role!(params[:role])
    render :nothing => true
  end
  
  private
  def get_authorization_subject_and_object
    pc = Illyan.permissioned_class(params[:item_klass])
    @authorization_subject = pc && pc.find(params[:item_id])
    
    if params[:klass] == 'Person'
      @authorization_object = Person.find(params[:id])
    else
      @authorization_object = Group.find(params[:id])
    end
  end
  
  def revoking_own_change_permissions_role?
    @authorization_object == logged_in_person and params[:role] == "change_permissions"
  end
end
