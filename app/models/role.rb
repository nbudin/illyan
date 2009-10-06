class Role < ActiveRecord::Base
  acts_as_authorization_role :subject => 'Person'
  acts_as_authorization_role :subject => 'Group'
end
