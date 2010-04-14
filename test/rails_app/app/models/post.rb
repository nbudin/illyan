class Post < ActiveRecord::Base
  illyan_authorization_object
  has_one :author, :class_name => "Person"
end