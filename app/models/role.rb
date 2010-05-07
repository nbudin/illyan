class Role < ActiveRecord::Base
  acts_as_authorization_role :subject_class_name => 'Person'
  acts_as_authorization_role :subject_class_name => 'Group'
  
  before_destroy do |role|
    role.people.empty? && role.groups.empty?
  end    
end
