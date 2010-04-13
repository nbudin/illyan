class Role < ActiveRecord::Base
  acts_as_authorization_role :subject_class_name => 'Person'
  acts_as_authorization_role :subject_class_name => 'Group'

  def before_destroy
    people.empty? && groups.empty?
  end
end
