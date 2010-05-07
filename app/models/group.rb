class Group < ActiveRecord::Base
  acts_as_authorization_subject
  
  has_and_belongs_to_many :people
end
