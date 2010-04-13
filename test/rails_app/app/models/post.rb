class Post < ActiveRecord::Base
  acts_as_authorization_object
  has_one :author, :class_name => "Person"
end