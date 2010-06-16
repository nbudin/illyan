class Group < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_and_belongs_to_many :owners, :class_name => 'Person'
end
