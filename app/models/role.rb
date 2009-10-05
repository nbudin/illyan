class Role < ActiveRecord::Base
  acts_as_ae_users_shared_model
  acts_as_permissioned :permission_names => ['edit']
  has_and_belongs_to_many :people
  has_many :permissions, :dependent => :destroy
end
